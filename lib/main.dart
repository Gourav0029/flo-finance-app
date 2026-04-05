import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'domain/models/transaction_model.dart';
import 'domain/models/user_profile_model.dart';
import 'domain/models/challenge_model.dart';
import 'domain/repositories/transaction_repository.dart';
import 'infrastructure/hive_transaction_repository.dart';
import 'core/theme/app_theme.dart';
import 'core/security/encryption_service.dart';
import 'routing/app_router.dart';
import 'application/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(ChallengeAdapter());

  // Get AES-256 encryption cipher (key stored in Android Keystore / iOS Keychain)
  final cipher = await EncryptionService.getEncryptionCipher();

  // Migrate: try opening existing unencrypted boxes, export data, re-open encrypted
  final transactionsBox = await _openEncryptedBox<Transaction>('transactionsBox', cipher);
  await _openEncryptedBox<UserProfile>('userProfileBox', cipher);
  await _openEncryptedBox<dynamic>('settingsBox', cipher);
  await _openEncryptedBox<Challenge>('challengesBox', cipher);

  runApp(
    ProviderScope(
      overrides: [
        transactionRepositoryProvider.overrideWithValue(
          HiveTransactionRepository(transactionsBox),
        ),
      ],
      child: const FloFinanceApp(),
    ),
  );
}

/// Opens a Hive box with encryption. If the box was previously unencrypted,
/// migrates data by reading → deleting → re-opening encrypted → restoring.
Future<Box<T>> _openEncryptedBox<T>(String boxName, HiveCipher cipher) async {
  try {
    // Try opening with encryption first (normal path after migration)
    return await Hive.openBox<T>(boxName, encryptionCipher: cipher);
  } catch (_) {
    // If it fails, the box exists unencrypted — migrate it
    try {
      final unencryptedBox = await Hive.openBox<T>(boxName);
      final existingData = unencryptedBox.values.toList();
      final existingKeys = unencryptedBox.keys.toList();
      await unencryptedBox.deleteFromDisk();

      final encryptedBox = await Hive.openBox<T>(boxName, encryptionCipher: cipher);
      // Restore data with original keys
      for (var i = 0; i < existingData.length; i++) {
        await encryptedBox.put(existingKeys[i], existingData[i]);
      }
      return encryptedBox;
    } catch (_) {
      // Last resort: delete and start fresh
      await Hive.deleteBoxFromDisk(boxName);
      return await Hive.openBox<T>(boxName, encryptionCipher: cipher);
    }
  }
}

class FloFinanceApp extends ConsumerWidget {
  const FloFinanceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeNotifierProvider);
    return MaterialApp.router(
      title: 'Flo Finance',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
