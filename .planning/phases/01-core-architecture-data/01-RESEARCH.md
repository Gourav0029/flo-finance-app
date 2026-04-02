# Phase 1: Core Architecture & Data - Research

**Objective:** Define the technical blueprint to implement the local-first Hive foundation with Riverpod repositories, executing synchronously in `main()`.

## Domain Analysis

- **Hive**: High-performance key-value NoSQL database suitable for offline-first setups. Required packages: `path_provider`, `hive`, `hive_flutter`.
- **TypeAdapters**: Dart models must be serialized. `hive_generator` combined with `build_runner` automates this cleanly.
- **Riverpod**: Centralized deterministic state dependency injection via `riverpod_generator` and `flutter_riverpod`.

## Key Technical Decisions Validated by Architecture

1. **Synchronous Boot**: By awaiting `Hive.initFlutter()` and `openBox()` locally prior to `runApp()`, we guarantee downstream widgets never encounter uninitialized storage errors or latency spinners.
2. **Abstract Repositories**: Injecting interfaces like `TransactionRepository` via `ProviderScope.overrides` isolates storage logic from UI.
3. **Distinct Boxes**: A `transactionsBox` instance specifically tied to the transactions data slice reduces parse overhead when data sizes grow.

## Implementation Blueprint

### 1. Build and Run Ecosystem Dependencies
Pubspec modifications required:
- *dependencies*: `hive`, `hive_flutter`, `flutter_riverpod`, `riverpod_annotation`, `path_provider`.
- *dev_dependencies*: `build_runner`, `hive_generator`, `riverpod_generator`, `custom_lint`, `riverpod_lint`.

### 2. Transaction Models
To comply with standard Hive conventions, use explicit annotations:
```dart
@HiveType(typeId: 0)
class Transaction {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final double amount;
  @HiveField(2)
  final String category;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final String notes;
  
  Transaction({/*...*/});
}
```

### 3. Repository Layers
The app will consume a strongly typed abstraction.
```dart
abstract interface class TransactionRepository {
  Future<void> addTransaction(Transaction tx);
  Future<void> updateTransaction(Transaction tx);
  Future<void> deleteTransaction(String id);
  List<Transaction> getAllTransactions();
}
```

### 4. Initialization Configuration
`main.dart` acts as the sync gatekeeper.
```dart
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
```

## Validation Architecture

To satisfy downstream QA logic, here is the matrix:

| Dimension | Strategy |
|-----------|----------|
| **D1: Static/Types** | Verify Riverpod generators complete without errors (`dart run build_runner build -d`). |
| **D2: Unit/Logic** | The `HiveTransactionRepository` will be unit tested using mock boxes to ensure add/delete operations alter internal map structure. |
| **D3: Core Integration**| Execution of `main()` resolves the database boot properly without throwing initialization errors. |
