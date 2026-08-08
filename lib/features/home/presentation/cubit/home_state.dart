import 'package:equatable/equatable.dart';
import '../../../../data/models/transaction_model.dart';
import '../../../../data/models/settings_model.dart';
import '../../../../data/models/notification_model.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final List<TransactionModel> allTransactions;
  final List<TransactionModel> recentTransactions;
  final double totalIncome;
  final double totalExpense;
  final double balance;
  final SettingsModel? settings;
  final Map<String, double> categoryExpenses;
  final List<NotificationModel> notifications;
  final bool showBudgetWarning;
  final String? error;

  const HomeState({
    this.isLoading = true,
    this.allTransactions = const [],
    this.recentTransactions = const [],
    this.totalIncome = 0,
    this.totalExpense = 0,
    this.balance = 0,
    this.settings,
    this.categoryExpenses = const {},
    this.notifications = const [],
    this.showBudgetWarning = false,
    this.error,
  });

  HomeState copyWith({
    bool? isLoading,
    List<TransactionModel>? allTransactions,
    List<TransactionModel>? recentTransactions,
    double? totalIncome,
    double? totalExpense,
    double? balance,
    SettingsModel? settings,
    Map<String, double>? categoryExpenses,
    List<NotificationModel>? notifications,
    bool? showBudgetWarning,
    String? error,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      allTransactions: allTransactions ?? this.allTransactions,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      balance: balance ?? this.balance,
      settings: settings ?? this.settings,
      categoryExpenses: categoryExpenses ?? this.categoryExpenses,
      notifications: notifications ?? this.notifications,
      showBudgetWarning: showBudgetWarning ?? this.showBudgetWarning,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        allTransactions,
        recentTransactions,
        totalIncome,
        totalExpense,
        balance,
        settings,
        categoryExpenses,
        notifications,
        showBudgetWarning,
        error
      ];
}
