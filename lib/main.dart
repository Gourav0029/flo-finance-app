import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'domain/models/transaction_model.dart';
import 'domain/repositories/transaction_repository.dart';
import 'infrastructure/hive_transaction_repository.dart';
import 'core/theme/app_theme.dart';
import 'routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
  
  final transactionsBox = await Hive.openBox<Transaction>('transactionsBox');

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

class FloFinanceApp extends ConsumerWidget {
  const FloFinanceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'Flo Finance',
      theme: AppTheme.lightTheme,
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
