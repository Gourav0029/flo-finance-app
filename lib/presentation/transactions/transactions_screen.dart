import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/currency_formatter.dart';
import '../../application/transactions_list_notifier.dart';
import 'widgets/transaction_icon.dart';
import 'widgets/add_transaction_bottom_sheet.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/app_icon.png',
              width: 28,
              height: 28,
            ),
            const SizedBox(width: 8),
            Text(
              'Flo',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: -0.5,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: TextField(
                onChanged: (value) => ref.read(transactionsFilterNotifierProvider.notifier).updateSearchQuery(value),
                decoration: InputDecoration(
                  hintText: 'Search transactions...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Row(
              children: [
                _buildFilterChip('All', ref, theme, colorScheme),
                const SizedBox(width: 8),
                _buildFilterChip('Food', ref, theme, colorScheme),
                const SizedBox(width: 8),
                _buildFilterChip('Transport', ref, theme, colorScheme),
                const SizedBox(width: 8),
                _buildFilterChip('Utilities', ref, theme, colorScheme),
              ],
            ),
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final transactions = ref.watch(transactionsListNotifierProvider);
                if (transactions.isEmpty) {
                  return Center(child: Text('No transactions found.', style: TextStyle(color: colorScheme.onSurfaceVariant)));
                }
                return ListView.builder(
                  itemCount: transactions.length,
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0, bottom: 100.0),
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    final isExpense = tx.amount < 0;
                    final displayAmount = isExpense 
                        ? '- ${CurrencyFormatter.formatINR(-tx.amount)}' 
                        : '+ ${CurrencyFormatter.formatINR(tx.amount)}';
                        
                    return Dismissible(
                      key: Key(tx.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.red.shade400,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        return await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete this transaction?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                }, 
                                child: const Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          )
                        );
                      },
                      onDismissed: (direction) {
                        ref.read(transactionsListNotifierProvider.notifier).deleteTransaction(tx.id);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: GestureDetector(
                          onLongPress: () {
                            showModalBottomSheet(
                              context: context, 
                              isScrollControlled: true, 
                              backgroundColor: Colors.transparent,
                              builder: (context) => AddTransactionBottomSheet(existingTx: tx)
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainer,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [BoxShadow(color: colorScheme.shadow.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 4))],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    TransactionIcon(category: tx.category),
                                    const SizedBox(width: 16),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(tx.category, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorScheme.onSurface)),
                                        Text(tx.notes.isEmpty ? DateFormat('MMM dd, yyyy').format(tx.date) : tx.notes, style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14)),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  displayAmount,
                                  style: TextStyle(
                                    color: isExpense ? Colors.red.shade700 : Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, WidgetRef ref, AppTheme theme, ColorScheme colorScheme) {
    final filters = ref.watch(transactionsFilterNotifierProvider);
    final isSelected = filters.selectedCategory == label;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        ref.read(transactionsFilterNotifierProvider.notifier).updateCategory(label);
      },
      backgroundColor: colorScheme.surfaceContainerHigh,
      selectedColor: theme.accent,
      labelStyle: TextStyle(
        color: isSelected ? theme.primary : colorScheme.onSurfaceVariant,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      side: BorderSide.none,
    );
  }
}
