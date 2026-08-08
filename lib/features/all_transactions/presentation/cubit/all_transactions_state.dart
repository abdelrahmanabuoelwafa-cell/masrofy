import 'package:equatable/equatable.dart';
import '../../../../data/models/transaction_model.dart';

class AllTransactionsState extends Equatable {
  final bool isLoading;
  final List<TransactionModel> allTransactions;
  final List<TransactionModel> filteredTransactions;
  final String searchQuery;
  final String activeFilter;
  final String? error;

  const AllTransactionsState({
    this.isLoading = true,
    this.allTransactions = const [],
    this.filteredTransactions = const [],
    this.searchQuery = '',
    this.activeFilter = 'all',
    this.error,
  });

  AllTransactionsState copyWith({
    bool? isLoading,
    List<TransactionModel>? allTransactions,
    List<TransactionModel>? filteredTransactions,
    String? searchQuery,
    String? activeFilter,
    String? error,
  }) {
    return AllTransactionsState(
      isLoading: isLoading ?? this.isLoading,
      allTransactions: allTransactions ?? this.allTransactions,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      searchQuery: searchQuery ?? this.searchQuery,
      activeFilter: activeFilter ?? this.activeFilter,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        allTransactions,
        filteredTransactions,
        searchQuery,
        activeFilter,
        error
      ];
}
