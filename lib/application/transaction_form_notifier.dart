import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_form_notifier.g.dart';

class TransactionFormState {
  final double? amount;
  final String category;
  final DateTime date;
  final String notes;

  TransactionFormState({
    this.amount,
    this.category = 'Food',
    DateTime? date,
    this.notes = '',
  }) : date = date ?? DateTime.now();

  TransactionFormState copyWith({
    double? amount,
    String? category,
    DateTime? date,
    String? notes,
  }) {
    return TransactionFormState(
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      notes: notes ?? this.notes,
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

  bool validate() {
    return state.amount != null && state.amount! > 0;
  }
}
