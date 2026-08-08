import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 0)
class TransactionModel extends HiveObject {
  @HiveField(0)
  int id = 0;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late double amount;

  @HiveField(3)
  late String type;

  @HiveField(4)
  late String category;

  @HiveField(5)
  late DateTime date;

  @HiveField(6)
  String? note;

  @HiveField(7)
  double? originalAmount;

  @HiveField(8)
  String? originalCurrencyCode;

  @HiveField(9)
  double? exchangeRate;

  @HiveField(10)
  String? originalCurrencyName;

  TransactionModel({
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.note,
    this.originalAmount,
    this.originalCurrencyCode,
    this.exchangeRate,
    this.originalCurrencyName,
  });

  TransactionModel copyWith({
    String? title,
    double? amount,
    String? type,
    String? category,
    DateTime? date,
    String? note,
    double? originalAmount,
    String? originalCurrencyCode,
    double? exchangeRate,
    String? originalCurrencyName,
  }) {
    return TransactionModel(
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      note: note ?? this.note,
      originalAmount: originalAmount ?? this.originalAmount,
      originalCurrencyCode: originalCurrencyCode ?? this.originalCurrencyCode,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      originalCurrencyName: originalCurrencyName ?? this.originalCurrencyName,
    )..id = id;
  }
}
