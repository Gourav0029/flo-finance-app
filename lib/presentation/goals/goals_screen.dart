import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../application/goals_notifier.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final goalsState = ref.watch(goalsNotifierProvider);

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/app_icon.png',
              width: 28,
              height: 28,
            ),
            const SizedBox(width: 8),
            Text(
              'Flo', 
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // No Spend Streak
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade300, Colors.red.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Text('🔥', style: TextStyle(fontSize: 28)),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'No-Spend Streak',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          '${goalsState.noSpendStreak} Days',
                          style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Savings Goal
              Text('Savings Goal', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Saved', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                            Text(
                              CurrencyFormatter.formatINR(goalsState.savingsSaved),
                              style: TextStyle(color: theme.primary, fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Target', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                            Text(
                              CurrencyFormatter.formatINR(goalsState.savingsTarget),
                              style: TextStyle(color: theme.primary, fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    LinearProgressIndicator(
                      value: goalsState.savingsTarget > 0 ? (goalsState.savingsSaved / goalsState.savingsTarget).clamp(0.0, 1.0) : 0,
                      minHeight: 12,
                      backgroundColor: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      valueColor: AlwaysStoppedAnimation<Color>(theme.secondary),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          side: BorderSide(color: theme.secondary),
                        ),
                        onPressed: () {
                          _showSetGoalDialog(context, ref, theme);
                        },
                        child: Text('Set Goal', style: TextStyle(color: theme.secondary, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Challenges List
              Text('Challenges History', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...goalsState.challenges.map((challenge) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))
                  ]
                ),
                child: Row(
                  children: [
                    Icon(Icons.emoji_events, color: Colors.amber.shade600),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        challenge,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                    Icon(Icons.check_circle, color: theme.secondary),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  void _showSetGoalDialog(BuildContext context, WidgetRef ref, AppTheme theme) {
    final controller = TextEditingController(text: ref.read(goalsNotifierProvider).savingsTarget.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Target'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter amount...',
              filled: true,
              fillColor: theme.background,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                final target = double.tryParse(controller.text);
                if (target != null) {
                  ref.read(goalsNotifierProvider.notifier).updateSavingsTarget(target);
                }
                Navigator.pop(context);
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      }
    );
  }
}
