import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../application/challenges_notifier.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/challenge_model.dart';

class AddChallengeBottomSheet extends ConsumerStatefulWidget {
  const AddChallengeBottomSheet({super.key});

  @override
  ConsumerState<AddChallengeBottomSheet> createState() => _AddChallengeBottomSheetState();
}

class _AddChallengeBottomSheetState extends ConsumerState<AddChallengeBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  String _selectedCategory = 'All Categories';
  final List<String> _categories = [
    'All Categories',
    'Food',
    'Shopping',
    'Transport',
    'Entertainment',
    'Health',
    'Other'
  ];

  DateTime _startDate = DateTime.now();
  int _durationDays = 7;
  DateTime? _customEndDate; // Used only if durationDays is 0 (custom)

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: theme.primary,
              onPrimary: Colors.white,
              onSurface: theme.secondary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_durationDays != 0) {
          _customEndDate = null;
        } else if (_customEndDate != null && _customEndDate!.isBefore(_startDate)) {
          _customEndDate = _startDate.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> _selectCustomEndDate() async {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final picked = await showDatePicker(
      context: context,
      initialDate: _customEndDate ?? _startDate.add(const Duration(days: 1)),
      firstDate: _startDate,
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: theme.primary,
              onPrimary: Colors.white,
              onSurface: theme.secondary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _durationDays = 0; // Custom
        _customEndDate = picked;
      });
    }
  }

  void _saveChallenge() {
    if (_formKey.currentState!.validate()) {
      final amount = double.parse(_amountController.text.replaceAll(',', ''));
      DateTime endDate;
      
      if (_durationDays > 0) {
        endDate = _startDate.add(Duration(days: _durationDays));
      } else {
        if (_customEndDate == null) return; // Prevent empty custom end date
        endDate = _customEndDate!;
      }

      final newChallenge = Challenge(
        id: const Uuid().v4(),
        name: _nameController.text.trim(),
        category: _selectedCategory,
        budgetLimit: amount,
        startDate: _startDate,
        endDate: endDate,
      );

      ref.read(challengesNotifierProvider.notifier).addChallenge(newChallenge);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final colorScheme = Theme.of(context).colorScheme;

    return DefaultTextStyle(
      style: TextStyle(fontFamily: 'Inter', color: colorScheme.onSurface),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'Start New Challenge',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.bold,
                        color: theme.primary,
                      ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Challenge Name',
                    hintText: 'e.g. No Eating Out',
                    labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theme.secondary, width: 2),
                    ),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Please enter a name' : null,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Category Focus',
                    labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theme.secondary, width: 2),
                    ),
                  ),
                  items: _categories.map((String category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                  decoration: InputDecoration(
                    labelText: 'Budget Limit',
                    prefixText: '₹ ',
                    prefixStyle: TextStyle(color: theme.primary, fontWeight: FontWeight.bold, fontSize: 16),
                    labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theme.secondary, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter budget limit';
                    if (double.tryParse(value) == null) return 'Enter a valid number';
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                
                Text('Duration', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: colorScheme.onSurfaceVariant)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildDurationChip(7, '7 Days', theme, colorScheme),
                    _buildDurationChip(14, '14 Days', theme, colorScheme),
                    _buildDurationChip(30, '30 Days', theme, colorScheme),
                    _buildCustomDurationChip(theme, colorScheme),
                  ],
                ),
                const SizedBox(height: 24),
                
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _selectStartDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Start Date', style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12)),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('dd MMM yyyy').format(_startDate),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.transparent),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('End Date', style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(
                              _durationDays > 0 
                                  ? DateFormat('dd MMM yyyy').format(_startDate.add(Duration(days: _durationDays)))
                                  : (_customEndDate != null ? DateFormat('dd MMM yyyy').format(_customEndDate!) : 'Select...'),
                              style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    onPressed: _saveChallenge,
                    child: const Text('Create Challenge', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDurationChip(int days, String label, AppTheme theme, ColorScheme colorScheme) {
    final isSelected = _durationDays == days;
    return InkWell(
      onTap: () {
        setState(() {
          _durationDays = days;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.secondary.withValues(alpha: 0.1) : Colors.transparent,
          border: Border.all(color: isSelected ? theme.secondary : colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? theme.secondary : colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
  
  Widget _buildCustomDurationChip(AppTheme theme, ColorScheme colorScheme) {
    final isSelected = _durationDays == 0;
    return InkWell(
      onTap: _selectCustomEndDate,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.secondary.withValues(alpha: 0.1) : Colors.transparent,
          border: Border.all(color: isSelected ? theme.secondary : colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'Custom',
          style: TextStyle(
            color: isSelected ? theme.secondary : colorScheme.onSurfaceVariant,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
