import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'goals_notifier.g.dart';

class GoalsState {
  final double savingsSaved;
  final double savingsTarget;
  final int noSpendStreak;
  final List<String> challenges;

  GoalsState({
    this.savingsSaved = 45000,
    this.savingsTarget = 100000,
    this.noSpendStreak = 4,
    this.challenges = const ['Weekend Coffee Free', 'Cook At Home Month', 'Save ₹5000 challenge'],
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
    return GoalsState();
  }

  void updateSavingsTarget(double target) {
    if (target > 0) {
      state = state.copyWith(savingsTarget: target);
    }
  }
}
