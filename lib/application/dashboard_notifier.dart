import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/repositories/transaction_repository.dart';

part 'dashboard_notifier.g.dart';

class DailySpend {
  final int weekday;
  final double amount;
  DailySpend(this.weekday, this.amount);
}

@riverpod
class DashboardNotifier extends _$DashboardNotifier {
  @override
  Future<List<DailySpend>> build() async {
    final repo = ref.watch(transactionRepositoryProvider);
    final transactions = repo.getAllTransactions();
    
    final today = DateTime.now();
    final sevenDaysAgo = today.subtract(const Duration(days: 7));
    
    final Map<int, double> aggregates = {
      for (var i = 1; i <= 7; i++) i: 0.0,
    };

    for (final tx in transactions) {
      if (tx.date.isAfter(sevenDaysAgo) && tx.date.isBefore(today.add(const Duration(days: 1)))) {
        aggregates[tx.date.weekday] = (aggregates[tx.date.weekday] ?? 0) + tx.amount;
      }
    }

    return aggregates.entries
        .map((e) => DailySpend(e.key, e.value))
        .toList();
  }
}
