// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 0;

  @override
  TransactionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TransactionModel(
      title: fields[1] as String,
      amount: fields[2] as double,
      type: fields[3] as String,
      category: fields[4] as String,
      date: fields[5] as DateTime,
      note: fields[6] as String?,
      originalAmount: fields[7] as double?,
      originalCurrencyCode: fields[8] as String?,
      exchangeRate: fields[9] as double?,
      originalCurrencyName: fields[10] as String?,
    )..id = fields[0] as int;
  }

  @override
  void write(BinaryWriter writer, TransactionModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.note)
      ..writeByte(7)
      ..write(obj.originalAmount)
      ..writeByte(8)
      ..write(obj.originalCurrencyCode)
      ..writeByte(9)
      ..write(obj.exchangeRate)
      ..writeByte(10)
      ..write(obj.originalCurrencyName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
