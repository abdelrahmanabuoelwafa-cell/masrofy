import 'package:equatable/equatable.dart';
import '../../../../data/models/transaction_model.dart';

class StatisticsState extends Equatable {
  final bool isLoading;
  final List<TransactionModel> filteredTransactions;
  final String selectedPeriod;
  final Map<String, double> categoryExpenses;
  final Map<DateTime, double> dailyExpenses;
  final String topCategory;
  final double topCategoryAmount;
  final double topCategoryPercentage;
  final double totalExpense;
  final String? error;

  const StatisticsState({
    this.isLoading = true,
    this.filteredTransactions = const [],
    this.selectedPeriod = 'This Month',
    this.categoryExpenses = const {},
    this.dailyExpenses = const {},
    this.topCategory = '',
    this.topCategoryAmount = 0,
    this.topCategoryPercentage = 0,
    this.totalExpense = 0,
    this.error,
  });

  StatisticsState copyWith({
    bool? isLoading,
    List<TransactionModel>? filteredTransactions,
    String? selectedPeriod,
    Map<String, double>? categoryExpenses,
    Map<DateTime, double>? dailyExpenses,
    String? topCategory,
    double? topCategoryAmount,
    double? topCategoryPercentage,
    double? totalExpense,
    String? error,
  }) {
    return StatisticsState(
      isLoading: isLoading ?? this.isLoading,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      categoryExpenses: categoryExpenses ?? this.categoryExpenses,
      dailyExpenses: dailyExpenses ?? this.dailyExpenses,
      topCategory: topCategory ?? this.topCategory,
      topCategoryAmount: topCategoryAmount ?? this.topCategoryAmount,
      topCategoryPercentage:
          topCategoryPercentage ?? this.topCategoryPercentage,
      totalExpense: totalExpense ?? this.totalExpense,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        filteredTransactions,
        selectedPeriod,
        categoryExpenses,
        dailyExpenses,
        topCategory,
        topCategoryAmount,
        topCategoryPercentage,
        totalExpense,
        error
      ];
}
