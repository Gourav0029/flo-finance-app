import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/transaction_model.dart';

part 'transaction_repository.g.dart';

abstract interface class TransactionRepository {
  Future<void> addTransaction(Transaction tx);
  Future<void> updateTransaction(Transaction tx);
  Future<void> deleteTransaction(String id);
  List<Transaction> getAllTransactions();
}

@riverpod
TransactionRepository transactionRepository(TransactionRepositoryRef ref) {
  throw UnimplementedError('transactionRepository must be overridden in main.dart ProviderScope');
}
