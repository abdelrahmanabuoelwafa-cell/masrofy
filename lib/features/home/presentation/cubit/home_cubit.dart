import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/local/isar_service.dart';
import '../../../../data/models/notification_model.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final IsarService _isarService;

  HomeCubit(this._isarService) : super(const HomeState()) {
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final now = DateTime.now();
      final transactions =
          await _isarService.getMonthlyTransactions(now.year, now.month);
      final settings = await _isarService.getSettings();

      double totalIncome = 0;
      double totalExpense = 0;
      Map<String, double> categoryExpenses = {};

      for (final t in transactions) {
        if (t.type == 'income') {
          totalIncome += t.amount;
        } else {
          totalExpense += t.amount;
          categoryExpenses[t.category] =
              (categoryExpenses[t.category] ?? 0) + t.amount;
        }
      }

final recent = transactions.take(4).toList();
      final notifications = await _isarService.getNotifications();

      // Budget warning logic
      double budget = settings?.monthlyBudget ?? 5000;
      bool showWarning = false;
      if (budget > 0 && totalExpense >= budget) {
        showWarning = true;
        // Save a budget exceeded notification (avoid duplicates on every load)
        final hasExistingExceeded = notifications.any((n) =>
            n.type == 'budget_exceeded' && n.date.month == now.month && n.date.year == now.year);
        if (!hasExistingExceeded) {
          final notification = NotificationModel(
            title: 'تنبيه الميزانية',
            message: 'لقد تجاوزت ميزانيتك الشهرية! أنفقت ${totalExpense.toStringAsFixed(2)} من ${budget.toStringAsFixed(2)}',
            date: DateTime.now(),
            isRead: false,
            type: 'budget_exceeded',
          );
          await _isarService.addNotification(notification);
        }
      }

      emit(state.copyWith(
        isLoading: false,
        allTransactions: transactions,
        recentTransactions: recent,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        balance: totalIncome - totalExpense,
        settings: settings,
        categoryExpenses: categoryExpenses,
        notifications: notifications,
        showBudgetWarning: showWarning,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> deleteTransaction(int id) async {
    await _isarService.deleteTransaction(id);
    await loadHomeData();
  }

Future<void> updateBudget(double budget) async {
    await _isarService.updateBudget(budget);
    // Reload full data so that balance card, warning banner and remaining
    // budget recompute and rebuild reactively (avoiding stale Hive object ref).
    await loadHomeData();
  }

Future<void> updateUserName(String name) async {
    await _isarService.updateUserName(name);
    final settings = await _isarService.getSettings();
    emit(state.copyWith(settings: settings));
  }

Future<void> loadNotifications() async {
    final notifications = await _isarService.getNotifications();
    emit(state.copyWith(notifications: notifications));
  }

  Future<void> markNotificationRead(int id) async {
    await _isarService.markNotificationRead(id);
    await loadNotifications();
  }

  Future<void> clearNotifications() async {
    await _isarService.clearNotifications();
    await loadNotifications();
  }

  Future<void> dismissBudgetWarning() async {
    emit(state.copyWith(showBudgetWarning: false));
  }
}
