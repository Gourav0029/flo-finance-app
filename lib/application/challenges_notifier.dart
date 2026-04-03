import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/models/challenge_model.dart';
import 'transactions_list_notifier.dart';

part 'challenges_notifier.g.dart';

enum ChallengeStatus {
  ACTIVE,
  COMPLETED,
  FAILED,
}

class ChallengeWithStatus {
  final Challenge challenge;
  final ChallengeStatus status;
  final double currentSpent;

  ChallengeWithStatus({
    required this.challenge,
    required this.status,
    required this.currentSpent,
  });
}

@riverpod
class ChallengesNotifier extends _$ChallengesNotifier {
  late Box<Challenge> _box;

  @override
  List<ChallengeWithStatus> build() {
    _box = Hive.box<Challenge>('challengesBox');
    final challenges = _box.values.toList();
    final transactions = ref.watch(transactionsListNotifierProvider);

    return challenges.map((challenge) {
      double spent = 0.0;

      // Calculate total spending in category between dates
      for (final tx in transactions) {
        if (tx.amount < 0) {
          // Normalize dates to safely ensure inclusive day boundaries
          final txDate = DateTime(tx.date.year, tx.date.month, tx.date.day);
          final startDate = DateTime(challenge.startDate.year, challenge.startDate.month, challenge.startDate.day);
          final endDate = DateTime(challenge.endDate.year, challenge.endDate.month, challenge.endDate.day);
          
          if ((txDate.isAfter(startDate) || txDate.isAtSameMomentAs(startDate)) && 
              (txDate.isBefore(endDate) || txDate.isAtSameMomentAs(endDate))) {
            if (challenge.category == 'All Categories' || tx.category == challenge.category) {
              spent += tx.amount.abs();
            }
          }
        }
      }

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final endDate = DateTime(challenge.endDate.year, challenge.endDate.month, challenge.endDate.day);
      
      ChallengeStatus status = ChallengeStatus.ACTIVE;
      
      // If endDate has passed (today is strictly after the end date)
      if (today.isAfter(endDate)) {
        if (spent <= challenge.budgetLimit) {
          status = ChallengeStatus.COMPLETED;
        } else {
          status = ChallengeStatus.FAILED;
        }
      }

      return ChallengeWithStatus(
        challenge: challenge,
        status: status,
        currentSpent: spent,
      );
    }).toList()
    ..sort((a, b) => b.challenge.startDate.compareTo(a.challenge.startDate));
  }

  Future<void> addChallenge(Challenge challenge) async {
    await _box.put(challenge.id, challenge);
    ref.invalidateSelf();
  }

  Future<void> deleteChallenge(String id) async {
    await _box.delete(id);
    ref.invalidateSelf();
  }
}
