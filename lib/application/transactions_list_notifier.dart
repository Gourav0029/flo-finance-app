import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/repositories/transaction_repository.dart';
import '../domain/models/transaction_model.dart';

part 'transactions_list_notifier.g.dart';

class TransactionsFilterState {
  final String searchQuery;
  final String selectedCategory;

  const TransactionsFilterState({
    this.searchQuery = '',
    this.selectedCategory = 'All',
  });

  TransactionsFilterState copyWith({
    String? searchQuery,
    String? selectedCategory,
  }) {
    return TransactionsFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

@riverpod
class TransactionsFilterNotifier extends _$TransactionsFilterNotifier {
  @override
  TransactionsFilterState build() {
    return const TransactionsFilterState();
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }
}

@riverpod
class TransactionsListNotifier extends _$TransactionsListNotifier {
  @override
  List<Transaction> build() {
    final repo = ref.watch(transactionRepositoryProvider);
    final filters = ref.watch(transactionsFilterNotifierProvider);
    
    var allTx = repo.getAllTransactions().toList();
    
    // Sort descending by date
    allTx.sort((a, b) => b.date.compareTo(a.date));

    // Apply specific query filters
    if (filters.searchQuery.isNotEmpty) {
      final query = filters.searchQuery.toLowerCase();
      allTx = allTx.where((tx) => 
        tx.notes.toLowerCase().contains(query) ||
        tx.amount.toString().contains(query)
      ).toList();
    }

    if (filters.selectedCategory != 'All') {
      allTx = allTx.where((tx) => tx.category == filters.selectedCategory).toList();
    }

    return allTx;
  }
  
  void deleteTransaction(String id) async {
    final repo = ref.read(transactionRepositoryProvider);
    await repo.deleteTransaction(id);
    ref.invalidateSelf(); // trigger rebuild
  }
}
