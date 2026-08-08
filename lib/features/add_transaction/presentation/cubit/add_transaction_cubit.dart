import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../data/local/isar_service.dart';
import '../../../../data/models/transaction_model.dart';
import 'add_transaction_state.dart';

class AddTransactionCubit extends Cubit<AddTransactionState> {
  final IsarService _isarService;

  AddTransactionCubit(this._isarService) : super(AddTransactionState());

  void toggleType(bool isExpense) {
    final fallbackCategory = _getFallbackCategory(isExpense);
    final nextCategory =
        _isCategoryValidForType(state.selectedCategory, isExpense)
            ? state.selectedCategory
            : fallbackCategory;
    emit(state.copyWith(isExpense: isExpense, selectedCategory: nextCategory));
  }

  void setAmount(double amount) => emit(state.copyWith(amount: amount));
  void selectCategory(String category) =>
      emit(state.copyWith(selectedCategory: category));
  void setDate(DateTime date) => emit(state.copyWith(selectedDate: date));
  void setTitle(String title) => emit(state.copyWith(title: title));
  void setNote(String note) => emit(state.copyWith(note: note));
  void clearError() => emit(state.copyWith(error: null));
  void setMultiCurrency(double? originalAmount, String? currencyCode,
          String? currencyName, double? exchangeRate) =>
      emit(state.copyWith(
          originalAmount: originalAmount,
          originalCurrencyCode: currencyCode,
          originalCurrencyName: currencyName,
          exchangeRate: exchangeRate));

  double get _finalEGP {
    if (state.originalCurrencyCode != null &&
        state.originalAmount != null &&
        state.exchangeRate != null) {
      return state.originalAmount! * state.exchangeRate!;
    }
    return state.amount;
  }

Future<void> saveTransaction() async {
    final finalAmount = _finalEGP;
    if (finalAmount <= 0) {
      emit(state.copyWith(error: 'error_amount_positive'));
      return;
    }
    emit(state.copyWith(isSaving: true, error: null));
    try {
      final catInfo = _getCategoryInfo(state.selectedCategory, state.isExpense);
      final transaction = TransactionModel(
        title: state.title.isNotEmpty ? state.title : (catInfo['ar'] as String),
        amount: finalAmount,
        type: state.isExpense
            ? AppConstants.expenseType
            : AppConstants.incomeType,
        category: state.selectedCategory,
        date: state.selectedDate,
        note: state.note,
        originalAmount: state.originalAmount,
        originalCurrencyCode: state.originalCurrencyCode,
        originalCurrencyName: state.originalCurrencyName,
        exchangeRate:
            state.originalCurrencyCode != null ? state.exchangeRate : null,
      );
      await _isarService.addTransaction(transaction);
      emit(state.copyWith(isSaving: false, isSaved: true));
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: 'error_generic'));
    }
  }

  Future<void> updateTransaction(TransactionModel original) async {
    final finalAmount = _finalEGP;
    if (finalAmount <= 0) {
      emit(state.copyWith(error: 'error_amount_positive'));
      return;
    }
    emit(state.copyWith(isSaving: true, error: null));
    try {
      final catInfo = _getCategoryInfo(state.selectedCategory, state.isExpense);
      final updated = TransactionModel(
        title: state.title.isNotEmpty ? state.title : (catInfo['ar'] as String),
        amount: finalAmount,
        type: state.isExpense
            ? AppConstants.expenseType
            : AppConstants.incomeType,
        category: state.selectedCategory,
        date: state.selectedDate,
        note: state.note,
        originalAmount: state.originalAmount,
        originalCurrencyCode: state.originalCurrencyCode,
        originalCurrencyName: state.originalCurrencyName,
        exchangeRate:
            state.originalCurrencyCode != null ? state.exchangeRate : null,
      )..id = original.id;
      await _isarService.updateTransaction(updated);
      emit(state.copyWith(isSaving: false, isSaved: true));
    } catch (e) {
      emit(state.copyWith(isSaving: false, error: 'error_generic'));
    }
  }

  String _getFallbackCategory(bool isExpense) {
    final categories = _getCategoriesForType(isExpense);
    return categories.first['name'] as String;
  }

  bool _isCategoryValidForType(String category, bool isExpense) {
    final categories = _getCategoriesForType(isExpense);
    return categories.any((c) => c['name'] == category);
  }

  Map<String, dynamic> _getCategoryInfo(String category, bool isExpense) {
    final categories = _getCategoriesForType(isExpense);
    return categories.firstWhere(
      (c) => c['name'] == category,
      orElse: () => _getFallbackCategoryInfo(isExpense),
    );
  }

  List<Map<String, dynamic>> _getCategoriesForType(bool isExpense) {
    return isExpense
        ? AppConstants.categories
        : [
            {
              'name': 'salary',
              'ar': 'مرتب',
              'emoji': '💰',
              'color': AppColors.income
            },
            {
              'name': 'freelance',
              'ar': 'فريلانس',
              'emoji': '💻',
              'color': AppColors.primary
            },
            {
              'name': 'gift',
              'ar': 'هدية',
              'emoji': '🎁',
              'color': AppColors.warning
            },
            {
              'name': 'other',
              'ar': 'أخرى',
              'emoji': '💸',
              'color': AppColors.textSecondary
            },
          ];
  }

  Map<String, dynamic> _getFallbackCategoryInfo(bool isExpense) {
    final categories = _getCategoriesForType(isExpense);
    return categories.first;
  }
}
