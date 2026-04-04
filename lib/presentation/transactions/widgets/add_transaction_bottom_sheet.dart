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

class AddTransactionBottomSheet extends ConsumerStatefulWidget {
  final Transaction? existingTx;
  const AddTransactionBottomSheet({super.key, this.existingTx});

  @override
  ConsumerState<AddTransactionBottomSheet> createState() => _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState extends ConsumerState<AddTransactionBottomSheet> {

  @override
  void initState() {
    super.initState();
    if (widget.existingTx != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final tx = widget.existingTx!;
        ref.read(transactionFormNotifierProvider.notifier).updateIsIncome(tx.amount > 0);
        ref.read(transactionFormNotifierProvider.notifier).updateAmount(tx.amount.abs().toString());
        ref.read(transactionFormNotifierProvider.notifier).updateCategory(tx.category);
        ref.read(transactionFormNotifierProvider.notifier).updateDate(tx.date);
        ref.read(transactionFormNotifierProvider.notifier).updateNotes(tx.notes);
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Reset form for new transactions
        ref.read(transactionFormNotifierProvider.notifier).updateAmount('');
        ref.read(transactionFormNotifierProvider.notifier).updateNotes('');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final colorScheme = Theme.of(context).colorScheme;
    final formState = ref.watch(transactionFormNotifierProvider);

    final List<String> categories = formState.isIncome 
        ? ['Income', 'Salary', 'Gift', 'Other'] 
        : ['Food', 'Transport', 'Utilities', 'Shopping', 'Bills', 'Other'];

    if (widget.existingTx != null && formState.amount == null && widget.existingTx!.amount != 0) {
      // Just waiting for the postFrameCallback
      return Container(height: 200, color: colorScheme.surface, child: const Center(child: CircularProgressIndicator()));
    }

    // Default category fallback
    final safeCategory = categories.contains(formState.category) ? formState.category : categories.first;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
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
                  widget.existingTx != null ? 'Edit Transaction' : 'Add Transaction',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => context.pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
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
            
            TextFormField(
              initialValue: widget.existingTx != null ? widget.existingTx!.amount.abs().toString() : '',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: 'Amount (₹)',
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
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
            
            DropdownButtonFormField<String>(
              value: safeCategory,
              decoration: InputDecoration(
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
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
                  color: colorScheme.surfaceContainerHighest,
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

            TextFormField(
              initialValue: widget.existingTx?.notes ?? '',
              decoration: InputDecoration(
                hintText: 'Notes',
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest,
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
                    
                    double finalAmount = formState.amount!;
                    if (!formState.isIncome) {
                      finalAmount = -finalAmount;
                    }
                    
                    if (widget.existingTx != null) {
                      ref.read(transactionsListNotifierProvider.notifier).deleteTransaction(widget.existingTx!.id);
                    }
                    
                    final newId = widget.existingTx?.id ?? const Uuid().v4();
                    
                    repo.addTransaction(
                      Transaction(
                        id: newId,
                        amount: finalAmount,
                        date: formState.date,
                        category: safeCategory,
                        notes: formState.notes,
                      ),
                    );
                    
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
                child: Text(
                  widget.existingTx != null ? 'Update Transaction' : 'Save Transaction',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
