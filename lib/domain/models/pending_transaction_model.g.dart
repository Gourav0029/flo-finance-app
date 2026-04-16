// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_transaction_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PendingTransactionAdapter extends TypeAdapter<PendingTransaction> {
  @override
  final int typeId = 5;

  @override
  PendingTransaction read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PendingTransaction(
      id: fields[0] as String,
      amount: fields[1] as double,
      isDebit: fields[2] as bool,
      date: fields[3] as DateTime,
      autoCategory: fields[4] as String,
      notes: fields[5] as String?,
      upiRef: fields[6] as String?,
      last4Digits: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PendingTransaction obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.isDebit)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.autoCategory)
      ..writeByte(5)
      ..write(obj.notes)
      ..writeByte(6)
      ..write(obj.upiRef)
      ..writeByte(7)
      ..write(obj.last4Digits);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PendingTransactionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
