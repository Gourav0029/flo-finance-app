import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../application/transaction_form_notifier.dart';
import '../../../../application/transactions_list_notifier.dart';
import '../../../../application/dashboard_notifier.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/repositories/transaction_repository.dart';
import '../../../../domain/models/transaction_model.dart';
import 'package:uuid/uuid.dart';

class AddTransactionBottomSheet extends ConsumerWidget {
  const AddTransactionBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final formState = ref.watch(transactionFormNotifierProvider);

    final List<String> categories = formState.isIncome 
        ? ['Income', 'Salary', 'Gift', 'Other'] 
        : ['Food', 'Transport', 'Utilities', 'Shopping', 'Bills', 'Other'];

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Transaction',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => context.pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Income / Expense Toggle
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Expense')),
                    selected: !formState.isIncome,
                    selectedColor: Colors.red.shade100,
                    onSelected: (val) {
                      if(val) ref.read(transactionFormNotifierProvider.notifier).updateIsIncome(false);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Income')),
                    selected: formState.isIncome,
                    selectedColor: Colors.green.shade100,
                    onSelected: (val) {
                      if(val) ref.read(transactionFormNotifierProvider.notifier).updateIsIncome(true);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Amount
            TextField(
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Amount (₹)',
                filled: true,
                fillColor: theme.background,
                prefixText: formState.isIncome ? '+ ' : '- ',
                prefixStyle: TextStyle(
                  color: formState.isIncome ? Colors.green.shade700 : Colors.red.shade700, 
                  fontWeight: FontWeight.bold, 
                  fontSize: 16
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) =>
                  ref.read(transactionFormNotifierProvider.notifier).updateAmount(value),
            ),
            const SizedBox(height: 16),
            
            // Category Dropdown
            DropdownButtonFormField<String>(
              value: categories.contains(formState.category) ? formState.category : categories.first,
              decoration: InputDecoration(
                filled: true,
                fillColor: theme.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              items: categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
              onChanged: (val) {
                if (val != null) {
                  ref.read(transactionFormNotifierProvider.notifier).updateCategory(val);
                }
              },
            ),
            const SizedBox(height: 16),
            
            // Date Picker Row
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: formState.date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  ref.read(transactionFormNotifierProvider.notifier).updateDate(date);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: theme.background,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('MMM dd, yyyy').format(formState.date)),
                    const Icon(Icons.calendar_today, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Notes
            TextField(
              decoration: InputDecoration(
                hintText: 'Notes',
                filled: true,
                fillColor: theme.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) =>
                  ref.read(transactionFormNotifierProvider.notifier).updateNotes(value),
            ),
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () {
                  final isValid = ref.read(transactionFormNotifierProvider.notifier).validate();
                  if (isValid) {
                    final repo = ref.read(transactionRepositoryProvider);
                    
                    // Format amount: negative if expense
                    double finalAmount = formState.amount!;
                    if (!formState.isIncome) {
                      finalAmount = -finalAmount;
                    }
                    
                    repo.addTransaction(
                      Transaction(
                        id: const Uuid().v4(),
                        amount: finalAmount,
                        date: formState.date,
                        category: formState.category,
                        notes: formState.notes,
                      ),
                    );
                    
                    // Invalidate providers to force UI refresh seamlessly!
                    ref.invalidate(transactionsListNotifierProvider);
                    ref.invalidate(dashboardNotifierProvider);
                    
                    context.pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Please enter a valid amount'),
                        backgroundColor: theme.accent,
                      ),
                    );
                  }
                },
                child: const Text(
                  'Save Transaction',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
