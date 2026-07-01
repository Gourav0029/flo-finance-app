import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/security/biometric_service.dart';
import '../../application/theme_notifier.dart';
import '../../application/transactions_list_notifier.dart';
import '../../application/user_profile_notifier.dart';
import '../../domain/models/user_profile_model.dart';
import '../widgets/profile_picture_sheet.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final colorScheme = Theme.of(context).colorScheme;
    final themeMode = ref.watch(themeNotifierProvider);
    final isDark = themeMode == ThemeMode.dark;

    final profile = ref.watch(userProfileNotifierProvider);
    final initials = profile?.name != null && profile!.name.isNotEmpty
        ? (profile.name.length == 1 ? profile.name.toUpperCase() : profile.name.substring(0, 2).toUpperCase())
        : '?';

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: theme.secondary.withValues(alpha: 0.1),
                    backgroundImage: profile?.profileImagePath != null ? FileImage(File(profile!.profileImagePath!)) : null,
                    child: profile?.profileImagePath == null
                        ? Text(initials, style: TextStyle(color: theme.secondary, fontWeight: FontWeight.bold, fontSize: 20))
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile?.name ?? 'User',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Flo Finance Member',
                          style: TextStyle(color: theme.onSurfaceVariant, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showEditProfileDialog(context, profile, theme),
                    child: Text('Edit', style: TextStyle(color: theme.secondary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Appearance
            Text('APPEARANCE', style: TextStyle(color: theme.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: theme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: theme.secondary),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Dark Mode',
                      style: TextStyle(fontWeight: FontWeight.w600, color: theme.onBackground),
                    ),
                  ),
                  Switch(
                    value: isDark,
                    onChanged: (val) {
                      ref.read(themeNotifierProvider.notifier).toggleTheme(val);
                    },
                    activeColor: theme.secondary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Security
            Text('SECURITY', style: TextStyle(color: theme.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
            const SizedBox(height: 12),
            FutureBuilder<bool>(
              future: BiometricService.isAvailable(),
              builder: (context, snapshot) {
                final isAvailable = snapshot.data ?? false;
                final settingsBox = Hive.box('settingsBox');
                final biometricEnabled = settingsBox.get('biometricEnabled', defaultValue: false) as bool;

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.fingerprint, color: theme.secondary),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Biometric Lock',
                              style: TextStyle(fontWeight: FontWeight.w600, color: theme.onBackground),
                            ),
                            Text(
                              isAvailable ? 'Require fingerprint to open app' : 'Not available on this device',
                              style: TextStyle(color: theme.onSurfaceVariant, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: biometricEnabled,
                        onChanged: isAvailable
                            ? (val) async {
                                await settingsBox.put('biometricEnabled', val);
                                setState(() {});
                              }
                            : null,
                        activeColor: theme.secondary,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            // Data
            Text('DATA', style: TextStyle(color: theme.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: theme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.download, color: theme.secondary),
                    title: Text('Export Transactions', style: TextStyle(fontWeight: FontWeight.w600, color: theme.onBackground)),
                    subtitle: Text('Share as CSV', style: TextStyle(color: theme.onSurfaceVariant, fontSize: 12)),
                    trailing: Icon(Icons.chevron_right, color: theme.onSurfaceVariant),
                    onTap: () => _exportTransactions(),
                  ),
                  Divider(height: 1, color: theme.onSurfaceVariant.withValues(alpha: 0.1)),
                  ListTile(
                    leading: const Icon(Icons.delete_forever, color: Colors.red),
                    title: const Text('Clear All Data', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red)),
                    subtitle: Text('Remove all transactions & settings', style: TextStyle(color: theme.onSurfaceVariant, fontSize: 12)),
                    trailing: Icon(Icons.chevron_right, color: theme.onSurfaceVariant),
                    onTap: () => _showClearDataDialog(context, theme),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // About
            Text('ABOUT', style: TextStyle(color: theme.onSurfaceVariant, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  Image.asset('assets/images/app_icon.png', width: 48, height: 48),
                  const SizedBox(height: 12),
                  Text('Flo Finance', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: theme.onBackground)),
                  const SizedBox(height: 4),
                  Text('Version 1.0.0', style: TextStyle(color: theme.onSurfaceVariant, fontSize: 13)),
                  const SizedBox(height: 12),
                  Text('© 2026 Gourav Kumar', style: TextStyle(color: theme.onSurfaceVariant, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _exportTransactions() {
    final txs = ref.read(transactionsListNotifierProvider);
    if (txs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No transactions to export')),
      );
      return;
    }

    final buffer = StringBuffer();
    buffer.writeln('Date,Category,Amount,Type,Description');
    for (final tx in txs) {
      final date = DateFormat('yyyy-MM-dd').format(tx.date);
      final type = tx.amount > 0 ? 'Income' : 'Expense';
      final desc = tx.notes.replaceAll(',', ' ');
      buffer.writeln('$date,${tx.category},${tx.amount.abs()},$type,$desc');
    }

    SharePlus.instance.share(ShareParams(text: buffer.toString(), subject: 'Flo Finance - Transactions Export'));
  }

  void _showClearDataDialog(BuildContext context, AppTheme theme) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear All Data?'),
        content: const Text('This will permanently delete all transactions, challenges, and settings. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: theme.onSurfaceVariant)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              await Hive.box('settingsBox').clear();
              await Hive.box<UserProfile>('userProfileBox').clear();
              // Transactions and challenges are cleared via their boxes
              final txBox = Hive.box<dynamic>('transactionsBox');
              await txBox.clear();
              if (Hive.isBoxOpen('challengesBox')) {
                await Hive.box<dynamic>('challengesBox').clear();
              }
              if (ctx.mounted) Navigator.pop(ctx);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All data cleared. Restart the app.')),
                );
              }
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, UserProfile? profile, AppTheme theme) {
    final nameCtrl = TextEditingController(text: profile?.name ?? '');
    String? imagePath = profile?.profileImagePath;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  final result = await showProfilePictureSheet(
                    ctx,
                    hasExistingPhoto: imagePath != null,
                  );
                  if (result != null) {
                    setDialogState(() {
                      if (result.removed) {
                        imagePath = null;
                      } else if (result.path != null) {
                        imagePath = result.path;
                      }
                    });
                  }
                },
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.secondary.withValues(alpha: 0.1),
                  backgroundImage: imagePath != null ? FileImage(File(imagePath!)) : null,
                  child: imagePath == null
                      ? Icon(Icons.camera_alt, color: theme.secondary, size: 28)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  hintText: 'Your name',
                  filled: true,
                  fillColor: theme.background,
                  border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: TextStyle(color: theme.onSurfaceVariant)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                final name = nameCtrl.text.trim().isEmpty ? (profile?.name ?? 'User') : nameCtrl.text.trim();
                ref.read(userProfileNotifierProvider.notifier).updateProfile(name, imagePath);
                Navigator.pop(ctx);
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
