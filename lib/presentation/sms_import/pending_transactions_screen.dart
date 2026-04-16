import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../application/sms_import_notifier.dart';
import '../../domain/models/pending_transaction_model.dart';
import '../transactions/widgets/transaction_icon.dart';

class PendingTransactionsScreen extends ConsumerWidget {
  const PendingTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final colorScheme = Theme.of(context).colorScheme;
    final pending = ref.watch(smsImportNotifierProvider);

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review Transactions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
            ),
            Text(
              '${pending.length} transaction${pending.length == 1 ? '' : 's'} detected from bank SMS',
              style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
            ),
          ],
        ),
      ),
      body: pending.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 64, color: const Color(0xFF64F9BC)),
                  const SizedBox(height: 16),
                  Text(
                    'All caught up!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No pending transactions.',
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: pending.length,
                    itemBuilder: (context, index) {
                      return _PendingTransactionCard(
                        pending: pending[index],
                        theme: theme,
                        colorScheme: colorScheme,
                      );
                    },
                  ),
                ),
                if (pending.length >= 2)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () async {
                          final notifier = ref.read(smsImportNotifierProvider.notifier);
                          // Confirm all with auto-detected categories
                          for (final p in List.of(pending)) {
                            await notifier.confirmTransaction(p, null, p.autoCategory);
                          }
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('All transactions saved!')),
                            );
                          }
                        },
                        child: const Text(
                          'Confirm All',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _PendingTransactionCard extends ConsumerStatefulWidget {
  final PendingTransaction pending;
  final AppTheme theme;
  final ColorScheme colorScheme;

  const _PendingTransactionCard({
    required this.pending,
    required this.theme,
    required this.colorScheme,
  });

  @override
  ConsumerState<_PendingTransactionCard> createState() =>
      _PendingTransactionCardState();
}

class _PendingTransactionCardState
    extends ConsumerState<_PendingTransactionCard> {
  late String _selectedCategory;
  final _notesController = TextEditingController();

  static const _categories = [
    'Food', 'Transport', 'Shopping', 'Bills',
    'Entertainment', 'Health', 'Income', 'Other',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.pending.autoCategory;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final txDay = DateTime(date.year, date.month, date.day);
    if (txDay == today) return 'Today';
    if (txDay == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return DateFormat('dd MMM').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.pending;
    final isExpense = p.isDebit;
    final displayAmount = isExpense
        ? '- ${CurrencyFormatter.formatINR(p.amount)}'
        : '+ ${CurrencyFormatter.formatINR(p.amount)}';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: widget.colorScheme.shadow.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TransactionIcon(category: _selectedCategory),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayAmount,
                      style: TextStyle(
                        color: isExpense ? Colors.red.shade700 : Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Auto-detected • ${p.upiRef != null ? "UPI" : "Bank SMS"}',
                      style: TextStyle(
                        color: widget.colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatDate(p.date),
                    style: TextStyle(
                      color: widget.colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                  if (p.last4Digits != null)
                    Text(
                      'A/c ••••${p.last4Digits}',
                      style: TextStyle(
                        color: widget.colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Category section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(
                'Category',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: widget.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  underline: const SizedBox(),
                  dropdownColor: widget.colorScheme.surfaceContainer,
                  style: TextStyle(
                    color: widget.colorScheme.onSurface,
                    fontSize: 14,
                  ),
                  items: _categories
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedCategory = val;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
          const SizedBox(height: 8),
          // Notes field
          TextField(
            controller: _notesController,
            decoration: InputDecoration(
              hintText: 'Add a note... (optional)',
              filled: true,
              fillColor: widget.colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    ref.read(smsImportNotifierProvider.notifier)
                        .dismissTransaction(p);
                  },
                  child: const Text('Dismiss', style: TextStyle(color: Colors.red)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF64F9BC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    await ref.read(smsImportNotifierProvider.notifier)
                        .confirmTransaction(
                      p,
                      _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
                      _selectedCategory,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Transaction saved!')),
                      );
                    }
                  },
                  child: Text(
                    'Save Transaction',
                    style: TextStyle(
                      color: widget.theme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
