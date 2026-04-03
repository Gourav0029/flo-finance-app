import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../application/transactions_list_notifier.dart';
class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.background,
        elevation: 0,
        title: Text(
          'Transactions',
          style: Theme.of(context).textTheme.headlineMedium,
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
                  fillColor: Colors.white,
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
                _buildFilterChip('All', ref, theme),
                const SizedBox(width: 8),
                _buildFilterChip('Food', ref, theme),
                const SizedBox(width: 8),
                _buildFilterChip('Transport', ref, theme),
                const SizedBox(width: 8),
                _buildFilterChip('Utilities', ref, theme),
              ],
            ),
          ),
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                final transactions = ref.watch(transactionsListNotifierProvider);
                if (transactions.isEmpty) {
                  return const Center(child: Text('No transactions found.'));
                }
                return ListView.builder(
                  itemCount: transactions.length,
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0, bottom: 100.0),
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    final isExpense = tx.amount < 0;
                    final displayAmount = isExpense 
                        ? '- ₹ ${(-tx.amount).toStringAsFixed(0)}' 
                        : '+ ₹ ${tx.amount.toStringAsFixed(0)}';
                        
                    IconData catIcon = Icons.help_outline;
                    if (tx.category == 'Food') catIcon = Icons.fastfood;
                    if (tx.category == 'Transport') catIcon = Icons.directions_car;
                    if (tx.category == 'Utilities') catIcon = Icons.bolt;
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: GestureDetector(
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Transaction'),
                              content: const Text('Are you sure you want to delete this transaction?'),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                                TextButton(
                                  onPressed: () {
                                    ref.read(transactionsListNotifierProvider.notifier).deleteTransaction(tx.id);
                                    Navigator.pop(context);
                                  }, 
                                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            )
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: theme.background,
                                    child: Icon(catIcon, color: theme.secondary),
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(tx.category, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      Text(tx.notes.isEmpty ? DateFormat('MMM dd, yyyy').format(tx.date) : tx.notes, style: const TextStyle(color: Colors.grey, fontSize: 14)),
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

  Widget _buildFilterChip(String label, WidgetRef ref, AppTheme theme) {
    final filters = ref.watch(transactionsFilterNotifierProvider);
    final isSelected = filters.selectedCategory == label;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        ref.read(transactionsFilterNotifierProvider.notifier).updateCategory(label);
      },
      backgroundColor: Colors.white,
      selectedColor: theme.accent,
      labelStyle: TextStyle(
        color: isSelected ? theme.primary : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      side: BorderSide.none,
    );
  }
}
