import 'package:flo_finance/application/transactions_list_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/models/transaction_model.dart';

part 'insights_notifier.g.dart';

class InsightsMatrix {
  final Map<String, double> categoryDistribution;
  final Map<int, double> monthlyTrend;

  InsightsMatrix(this.categoryDistribution, this.monthlyTrend);
}

InsightsMatrix _aggregateDataOffThread(List<Transaction> transactions) {
  final now = DateTime.now();

  // Isolate current month txs for category dist
  final Map<String, double> categories = {};
  final Map<int, double> trends = {for (var i = 1; i <= 6; i++) i: 0.0};

  for (final tx in transactions) {
    if (tx.date.year == now.year && tx.date.month == now.month) {
      categories[tx.category] = (categories[tx.category] ?? 0.0) + tx.amount;
    }

    // Calculate last 6 months trend mapping month integer (1-12) securely.
    if (tx.date.isAfter(DateTime(now.year, now.month - 5, 1))) {
      trends[tx.date.month] = (trends[tx.date.month] ?? 0.0) + tx.amount;
    }
  }

  return InsightsMatrix(categories, trends);
}

@riverpod
class InsightsNotifier extends _$InsightsNotifier {
  @override
  Future<InsightsMatrix> build() async {
    // Watch transactions list so insights recomputes
    // every time a transaction is added, edited or deleted
    final txs = ref.watch(transactionsListNotifierProvider);
    return await compute(_aggregateDataOffThread, txs);
  }
}
