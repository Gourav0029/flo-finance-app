import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import '../presentation/widgets/glass_nav.dart';
import '../presentation/widgets/ai_coach_fab.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/transactions/transactions_screen.dart';
import '../presentation/transactions/widgets/add_transaction_bottom_sheet.dart';
import '../presentation/insights/insights_screen.dart';
import '../presentation/goals/goals_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          final theme = Theme.of(context).extension<AppTheme>()!;
          
          return Scaffold(
            extendBody: true,
            body: navigationShell,
            floatingActionButton: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (navigationShell.currentIndex == 0 || navigationShell.currentIndex == 1) ...[
                  FloatingActionButton(
                    heroTag: 'addTxFab',
                    backgroundColor: theme.primary,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const AddTransactionBottomSheet(),
                      );
                    },
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                ],
                const AiCoachFAB(),
              ],
            ),
            bottomNavigationBar: GlassNav(
              currentIndex: navigationShell.currentIndex,
              onTap: (index) => navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              ),
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/transactions',
                builder: (context, state) => const TransactionsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/goals',
                builder: (context, state) => const GoalsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/insights',
                builder: (context, state) => const InsightsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
