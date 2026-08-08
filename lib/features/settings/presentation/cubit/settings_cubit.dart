import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/local/isar_service.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final IsarService _isarService;
  SettingsCubit(this._isarService) : super(const SettingsState()) {
    loadSettings();
  }

  Future<void> loadSettings() async {
    emit(state.copyWith(isLoading: true));
    try {
      final settings = await _isarService.getSettings();
      final now = DateTime.now();
      final transactions =
          await _isarService.getMonthlyTransactions(now.year, now.month);
      double monthlyExpense = 0;
      for (final t in transactions) {
        if (t.type == 'expense') monthlyExpense += t.amount;
      }
      final budget = settings?.monthlyBudget ?? 5000;
      final pct = budget > 0
          ? (monthlyExpense / budget).clamp(0.0, 1.5).toDouble()
          : 0.0;
      final remaining = budget - monthlyExpense;
      emit(state.copyWith(
          isLoading: false,
          settings: settings,
          budgetPercentage: pct,
          remainingBudget: remaining));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> updateBudget(double budget) async {
    await _isarService.updateBudget(budget);
    await loadSettings();
  }

  Future<void> toggleDarkMode(bool isDark) async {
    await _isarService.updateDarkMode(isDark);
    emit(state.copyWith(settings: await _isarService.getSettings()));
  }

  Future<void> updateUserName(String name) async {
    await _isarService.updateUserName(name);
    emit(state.copyWith(settings: await _isarService.getSettings()));
  }

  Future<void> clearAllData() async {
    await _isarService.clearAllTransactions();
    emit(state.copyWith(dataCleared: true));
    await loadSettings();
  }
}
