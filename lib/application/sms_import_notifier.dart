import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../core/sms/sms_service.dart';
import '../domain/models/pending_transaction_model.dart';
import '../domain/models/transaction_model.dart';
import '../domain/repositories/transaction_repository.dart';
import 'transactions_list_notifier.dart';

part 'sms_import_notifier.g.dart';

@riverpod
class SmsImportNotifier extends _$SmsImportNotifier {
  @override
  List<PendingTransaction> build() {
    final box = Hive.box<PendingTransaction>('pendingTransactionsBox');
    return box.values.toList();
  }

  /// Scans device SMS for bank transactions and saves new ones as pending.
  Future<void> scanSms() async {
    final parsed = await SmsService.fetchBankSms();
    final box = Hive.box<PendingTransaction>('pendingTransactionsBox');

    // Avoid duplicates by checking UPI ref
    final existingRefs = box.values
        .map((t) => t.upiRef)
        .whereType<String>()
        .toSet();

    for (final tx in parsed) {
      if (tx.upiRef != null && existingRefs.contains(tx.upiRef)) continue;
      final pending = PendingTransaction(
        id: const Uuid().v4(),
        amount: tx.amount,
        isDebit: tx.isDebit,
        date: tx.date,
        autoCategory: tx.detectedCategory,
        upiRef: tx.upiRef,
        last4Digits: tx.last4Digits,
      );
      await box.add(pending);
    }
    state = box.values.toList();
  }

  /// Confirms a pending transaction: saves it to official transactions and removes from pending.
  Future<void> confirmTransaction(
    PendingTransaction pending,
    String? notes,
    String category,
  ) async {
    final tx = Transaction(
      id: pending.id,
      amount: pending.isDebit ? -pending.amount : pending.amount,
      category: category,
      date: pending.date,
      notes: notes ?? (pending.upiRef != null ? 'UPI: ${pending.upiRef}' : ''),
    );
    final repo = ref.read(transactionRepositoryProvider);
    await repo.addTransaction(tx);
    ref.invalidate(transactionsListNotifierProvider);

    // Remove from pending
    await pending.delete();
    state = Hive.box<PendingTransaction>('pendingTransactionsBox')
        .values
        .toList();
  }

  /// Dismisses a pending transaction without saving.
  Future<void> dismissTransaction(PendingTransaction pending) async {
    await pending.delete();
    state = Hive.box<PendingTransaction>('pendingTransactionsBox')
        .values
        .toList();
  }
}
