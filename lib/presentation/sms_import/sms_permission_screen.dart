import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/sms/sms_service.dart';
import '../../core/theme/app_theme.dart';
import '../../application/sms_import_notifier.dart';

class SmsPermissionScreen extends ConsumerWidget {
  const SmsPermissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF64F9BC).withValues(alpha: 0.1),
                ),
                child: const Icon(
                  Icons.security,
                  size: 56,
                  color: Color(0xFF64F9BC),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Auto-import transactions',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Flo can detect bank transactions from your SMS messages — all processing happens locally on your device.',
                style: TextStyle(
                  fontSize: 15,
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _PrivacyPoint(
                icon: Icons.phone_android,
                text: 'Messages are read only on this device',
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 12),
              _PrivacyPoint(
                icon: Icons.cloud_off,
                text: 'Raw SMS is never stored or uploaded',
                colorScheme: colorScheme,
              ),
              const SizedBox(height: 12),
              _PrivacyPoint(
                icon: Icons.lock_outline,
                text: 'Only amount, date and type are saved to Flo',
                colorScheme: colorScheme,
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () async {
                    final granted = await SmsService.requestPermission();
                    final settingsBox = Hive.box('settingsBox');
                    if (granted) {
                      await settingsBox.put('smsEnabled', true);
                      await settingsBox.put('smsPermissionAsked', true);
                      await ref.read(smsImportNotifierProvider.notifier).scanSms();
                      if (context.mounted) context.go('/home');
                    } else {
                      await settingsBox.put('smsPermissionAsked', true);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Permission denied. Enable from Settings > App permissions.'),
                          ),
                        );
                        context.go('/home');
                      }
                    }
                  },
                  child: const Text(
                    'Enable Auto-Import',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  final settingsBox = Hive.box('settingsBox');
                  settingsBox.put('smsPermissionAsked', true);
                  context.go('/home');
                },
                child: Text(
                  'Skip for now',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrivacyPoint extends StatelessWidget {
  final IconData icon;
  final String text;
  final ColorScheme colorScheme;

  const _PrivacyPoint({
    required this.icon,
    required this.text,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF64F9BC).withValues(alpha: 0.1),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF64F9BC)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
