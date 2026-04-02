import 'package:hive/hive.dart';
import '../domain/models/transaction_model.dart';
import '../domain/repositories/transaction_repository.dart';

class HiveTransactionRepository implements TransactionRepository {
  final Box<Transaction> _box;

  HiveTransactionRepository(this._box);

  @override
  Future<void> addTransaction(Transaction tx) async {
    await _box.put(tx.id, tx);
  }

  @override
  Future<void> updateTransaction(Transaction tx) async {
    await _box.put(tx.id, tx);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
  }

  @override
  List<Transaction> getAllTransactions() {
    return _box.values.toList();
  }
}
