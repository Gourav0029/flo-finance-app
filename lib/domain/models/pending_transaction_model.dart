import 'package:hive/hive.dart';

part 'pending_transaction_model.g.dart';

@HiveType(typeId: 5)
class PendingTransaction extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final bool isDebit;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String autoCategory;

  @HiveField(5)
  final String? notes;

  @HiveField(6)
  final String? upiRef;

  @HiveField(7)
  final String? last4Digits;

  PendingTransaction({
    required this.id,
    required this.amount,
    required this.isDebit,
    required this.date,
    required this.autoCategory,
    this.notes,
    this.upiRef,
    this.last4Digits,
  });
}
