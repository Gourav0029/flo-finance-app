import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class GlassNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const GlassNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
        child: Container(
          height: 80,
          color: colorScheme.surface.withValues(alpha: 0.85),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, 'Home', theme, colorScheme),
              _buildNavItem(1, Icons.list_rounded, 'Transactions', theme, colorScheme),
              _buildNavItem(2, Icons.star_rounded, 'Goals', theme, colorScheme),
              _buildNavItem(3, Icons.insights_rounded, 'Insights', theme, colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, AppTheme theme, ColorScheme colorScheme) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: isSelected ? theme.secondary : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? theme.secondary : colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
