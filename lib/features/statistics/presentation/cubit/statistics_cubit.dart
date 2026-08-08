import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/local/isar_service.dart';
import 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final IsarService _isarService;
  StatisticsCubit(this._isarService) : super(const StatisticsState()) {
    loadStatistics('This Month');
  }

  void changePeriod(String period) {
    emit(state.copyWith(selectedPeriod: period));
    loadStatistics(period);
  }

  Future<void> loadStatistics(String period) async {
    emit(state.copyWith(isLoading: true));
    try {
      final now = DateTime.now();
      var transactions = await (period == 'This Week'
          ? _isarService.getWeeklyTransactions()
          : period == 'This Year'
              ? _isarService.getYearlyTransactions(now.year)
              : _isarService.getMonthlyTransactions(now.year, now.month));

      final expenses = transactions.where((t) => t.type == 'expense').toList();
      Map<String, double> categoryExpenses = {};
      Map<DateTime, double> dailyExpenses = {};
      double totalExpense = 0;

      for (final t in expenses) {
        totalExpense += t.amount;
        categoryExpenses[t.category] =
            (categoryExpenses[t.category] ?? 0) + t.amount;
        final dayKey = DateTime(t.date.year, t.date.month, t.date.day);
        dailyExpenses[dayKey] = (dailyExpenses[dayKey] ?? 0) + t.amount;
      }

      String topCat = '';
      double topAmount = 0;
      categoryExpenses.forEach((cat, amount) {
        if (amount > topAmount) {
          topAmount = amount;
          topCat = cat;
        }
      });
      final percentage =
          totalExpense > 0 ? (topAmount / totalExpense) * 100 : 0.0;

      emit(state.copyWith(
        isLoading: false,
        categoryExpenses: categoryExpenses,
        dailyExpenses: Map.fromEntries(dailyExpenses.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key))),
        topCategory: topCat,
        topCategoryAmount: topAmount,
        topCategoryPercentage: percentage,
        totalExpense: totalExpense,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
