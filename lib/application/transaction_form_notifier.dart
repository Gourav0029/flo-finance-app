import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_form_notifier.g.dart';

class TransactionFormState {
  final double? amount;
  final String category;
  final DateTime date;
  final String notes;
  final bool isIncome;

  TransactionFormState({
    this.amount,
    this.category = 'Food',
    DateTime? date,
    this.notes = '',
    this.isIncome = false,
  }) : date = date ?? DateTime.now();

  TransactionFormState copyWith({
    double? amount,
    String? category,
    DateTime? date,
    String? notes,
    bool? isIncome,
  }) {
    return TransactionFormState(
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      isIncome: isIncome ?? this.isIncome,
    );
  }
}

@riverpod
class TransactionFormNotifier extends _$TransactionFormNotifier {
  @override
  TransactionFormState build() {
    return TransactionFormState();
  }

  void updateAmount(String value) {
    state = state.copyWith(amount: double.tryParse(value));
  }

  void updateCategory(String category) {
    state = state.copyWith(category: category);
  }

  void updateDate(DateTime date) {
    state = state.copyWith(date: date);
  }
  
  void updateNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  void updateIsIncome(bool isIncome) {
    state = state.copyWith(isIncome: isIncome, category: isIncome ? 'Income' : 'Food');
  }

  bool validate() {
    return state.amount != null && state.amount! > 0;
  }
}
