import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../domain/models/user_profile_model.dart';
import '../core/theme/app_theme.dart';
import '../presentation/widgets/glass_nav.dart';
import '../presentation/widgets/ai_coach_fab.dart';
import '../presentation/home/home_screen.dart';
import '../presentation/transactions/transactions_screen.dart';
import '../presentation/transactions/widgets/add_transaction_bottom_sheet.dart';
import '../presentation/insights/insights_screen.dart';
import '../presentation/goals/goals_screen.dart';
import '../presentation/onboarding/welcome_screen.dart';
import '../presentation/settings/settings_screen.dart';
import '../presentation/lock/lock_screen.dart';
import '../presentation/sms_import/sms_permission_screen.dart';
import '../presentation/sms_import/pending_transactions_screen.dart';

/// Tracks whether this is the first navigation after cold start.
class AppState {
  static bool isFirstLoad = true;
}

CustomTransitionPage<void> _fadeSlideTransition({
  required Widget child,
  required LocalKey? key,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.05),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: child,
        ),
      );
    },
  );
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final userProfileBox = Hive.box<UserProfile>('userProfileBox');
  final isFirstLaunch = userProfileBox.isEmpty;

  final settingsBox = Hive.box('settingsBox');
  final biometricEnabled = settingsBox.get('biometricEnabled', defaultValue: false) as bool;

  // Determine initial location
  String initialLocation;
  if (isFirstLaunch) {
    initialLocation = '/welcome';
  } else if (biometricEnabled && AppState.isFirstLoad) {
    initialLocation = '/lock';
    AppState.isFirstLoad = false;
  } else {
    initialLocation = '/home';
  }

  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/welcome',
        pageBuilder: (context, state) => _fadeSlideTransition(
          key: state.pageKey,
          child: const WelcomeScreen(),
        ),
      ),
      GoRoute(
        path: '/lock',
        pageBuilder: (context, state) => _fadeSlideTransition(
          key: state.pageKey,
          child: const LockScreen(),
        ),
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => _fadeSlideTransition(
          key: state.pageKey,
          child: const SettingsScreen(),
        ),
      ),
      GoRoute(
        path: '/sms-permission',
        pageBuilder: (context, state) => _fadeSlideTransition(
          key: state.pageKey,
          child: const SmsPermissionScreen(),
        ),
      ),
      GoRoute(
        path: '/pending-transactions',
        pageBuilder: (context, state) => _fadeSlideTransition(
          key: state.pageKey,
          child: const PendingTransactionsScreen(),
        ),
      ),
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
                pageBuilder: (context, state) => _fadeSlideTransition(
                  key: state.pageKey,
                  child: const HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/transactions',
                pageBuilder: (context, state) => _fadeSlideTransition(
                  key: state.pageKey,
                  child: const TransactionsScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/goals',
                pageBuilder: (context, state) => _fadeSlideTransition(
                  key: state.pageKey,
                  child: const GoalsScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/insights',
                pageBuilder: (context, state) => _fadeSlideTransition(
                  key: state.pageKey,
                  child: const InsightsScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
