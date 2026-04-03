import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String formatINR(double amount) {
    // NumberFormat.currency with en_IN uses the Indian numbering system natively
    // Uses commas like 1,24,500
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
}
