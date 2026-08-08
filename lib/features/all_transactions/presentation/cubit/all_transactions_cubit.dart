import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/local/isar_service.dart';
import '../../../../data/models/transaction_model.dart';
import 'all_transactions_state.dart';

class AllTransactionsCubit extends Cubit<AllTransactionsState> {
  final IsarService _isarService;
  AllTransactionsCubit(this._isarService)
      : super(const AllTransactionsState()) {
    loadAllTransactions();
  }

  Future<void> loadAllTransactions() async {
    emit(state.copyWith(isLoading: true));
    try {
      final transactions = await _isarService.getAllTransactions();
      emit(state.copyWith(
          isLoading: false,
          allTransactions: transactions,
          filteredTransactions: transactions));
      applyFilters();
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
    applyFilters();
  }

  void setFilter(String filter) {
    emit(state.copyWith(activeFilter: filter));
    applyFilters();
  }

  void applyFilters() {
    var result = List<TransactionModel>.from(state.allTransactions);
    if (state.activeFilter != 'all') {
      if (state.activeFilter == 'expense' || state.activeFilter == 'income') {
        result = result.where((t) => t.type == state.activeFilter).toList();
      } else {
        result = result.where((t) => t.category == state.activeFilter).toList();
      }
    }
    if (state.searchQuery.isNotEmpty) {
      final q = state.searchQuery.toLowerCase();
      result = result
          .where((t) =>
              t.title.toLowerCase().contains(q) ||
              (t.note?.toLowerCase().contains(q) ?? false) ||
              t.amount.toString().contains(q))
          .toList();
    }
    emit(state.copyWith(filteredTransactions: result));
  }

  Future<void> deleteTransaction(int id) async {
    await _isarService.deleteTransaction(id);
    await loadAllTransactions();
  }
}
