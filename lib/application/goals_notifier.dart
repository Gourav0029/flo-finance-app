import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import './transactions_list_notifier.dart';

part 'goals_notifier.g.dart';

class GoalsState {
  final double savingsSaved;
  final double savingsTarget;
  final int noSpendStreak;
  final List<String> challenges;

  GoalsState({
    required this.savingsSaved,
    required this.savingsTarget,
    required this.noSpendStreak,
    required this.challenges,
  });

  GoalsState copyWith({
    double? savingsSaved,
    double? savingsTarget,
    int? noSpendStreak,
    List<String>? challenges,
  }) {
    return GoalsState(
      savingsSaved: savingsSaved ?? this.savingsSaved,
      savingsTarget: savingsTarget ?? this.savingsTarget,
      noSpendStreak: noSpendStreak ?? this.noSpendStreak,
      challenges: challenges ?? this.challenges,
    );
  }
}

@riverpod
class GoalsNotifier extends _$GoalsNotifier {
  @override
  GoalsState build() {
    final txs = ref.watch(transactionsListNotifierProvider);
    
    // Calculate total saved safely
    double income = 0;
    double expenses = 0;
    for (final tx in txs) {
      if (tx.amount > 0) income += tx.amount;
      if (tx.amount < 0) expenses += tx.amount.abs();
    }
    double saved = income - expenses;
    if (saved < 0) saved = 0;

    // Calculate No-Spend Streak correctly
    final expensesByDate = <String, bool>{};
    for (final tx in txs) {
      if (tx.amount < 0) {
        final dateStr = DateFormat('yyyy-MM-dd').format(tx.date);
        expensesByDate[dateStr] = true;
      }
    }

    int streak = 0;
    final today = DateTime.now();
    for (int i = 0; i < 1000; i++) {
        final d = today.subtract(Duration(days: i));
        final dStr = DateFormat('yyyy-MM-dd').format(d);
        if (expensesByDate.containsKey(dStr)) {
            break; 
        }
        streak++;
    }

    // Capture target from Hive explicitly
    final settingsBox = Hive.box('settingsBox');
    final target = settingsBox.get('savingsTarget', defaultValue: 100000.0) as double;

    return GoalsState(
       savingsSaved: saved,
       savingsTarget: target, 
       noSpendStreak: streak,
       challenges: const ['Weekend Coffee Free', 'Cook At Home Month', 'Save ₹5000 challenge'],
    );
  }

  void updateSavingsTarget(double target) {
    if (target > 0) {
      final settingsBox = Hive.box('settingsBox');
      settingsBox.put('savingsTarget', target);
      state = state.copyWith(savingsTarget: target);
    }
  }
}
