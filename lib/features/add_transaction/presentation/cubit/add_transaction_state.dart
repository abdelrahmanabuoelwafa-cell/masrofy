import 'package:equatable/equatable.dart';

class AddTransactionState extends Equatable {
  final bool isSaving;
  final bool isExpense;
  final double amount;
  final String selectedCategory;
  final DateTime selectedDate;
  final String title;
  final String? note;
  final String? error;
  final bool isSaved;
  final double? originalAmount;
  final String? originalCurrencyCode;
  final String? originalCurrencyName;
  final double? exchangeRate;

  AddTransactionState({
    this.isSaving = false,
    this.isExpense = true,
    this.amount = 0,
    this.selectedCategory = 'food',
    DateTime? selectedDate,
    this.title = '',
    this.note,
    this.error,
    this.isSaved = false,
    this.originalAmount,
    this.originalCurrencyCode,
    this.originalCurrencyName,
    this.exchangeRate,
  }) : selectedDate = selectedDate ?? DateTime.now();

  AddTransactionState copyWith({
    bool? isSaving,
    bool? isExpense,
    double? amount,
    String? selectedCategory,
    DateTime? selectedDate,
    String? title,
    String? note,
    String? error,
    bool? isSaved,
    double? originalAmount,
    String? originalCurrencyCode,
    String? originalCurrencyName,
    double? exchangeRate,
  }) {
    return AddTransactionState(
      isSaving: isSaving ?? this.isSaving,
      isExpense: isExpense ?? this.isExpense,
      amount: amount ?? this.amount,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedDate: selectedDate ?? this.selectedDate,
      title: title ?? this.title,
      note: note ?? this.note,
      error: error,
      isSaved: isSaved ?? this.isSaved,
      originalAmount: originalAmount ?? this.originalAmount,
      originalCurrencyCode: originalCurrencyCode ?? this.originalCurrencyCode,
      originalCurrencyName: originalCurrencyName ?? this.originalCurrencyName,
      exchangeRate: exchangeRate ?? this.exchangeRate,
    );
  }

  @override
  List<Object?> get props => [
        isSaving,
        isExpense,
        amount,
        selectedCategory,
        selectedDate,
        title,
        note,
        error,
        isSaved,
        originalAmount,
        originalCurrencyCode,
        originalCurrencyName,
        exchangeRate
      ];
}
