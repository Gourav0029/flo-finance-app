import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'ai_coach_bottom_sheet.dart';

class AiCoachFAB extends StatelessWidget {
  const AiCoachFAB({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const AiCoachBottomSheet(),
        );
      },
      backgroundColor: theme.primary,
      child: const Icon(Icons.auto_awesome, color: Colors.white),
    );
  }
}
