import 'package:intl/intl.dart';

/// Parsed result from a bank SMS message.
class ParsedSmsTransaction {
  final double amount;
  final bool isDebit;
  final DateTime date;
  final String? last4Digits;
  final String? upiRef;
  final String rawSms;
  final String detectedCategory;
  final String? payeeName;

  ParsedSmsTransaction({
    required this.amount,
    required this.isDebit,
    required this.date,
    this.last4Digits,
    this.upiRef,
    required this.rawSms,
    required this.detectedCategory,
    this.payeeName,
  });
}

/// Pure Dart SMS parser — no Flutter dependencies.
/// Parses raw Indian bank SMS text into structured transaction data
/// using bank-specific regex patterns tested against real SMS formats.
class SmsParser {
  /// TRAI-compliant sender ID detection.
  /// All Indian bank transactional SMS sender IDs end with '-S'.
  static bool isBankSms(String sender) {
    if (!sender.toUpperCase().endsWith('-S')) return false;

    const bankKeywords = [
      'ICICIT', 'ICICIB', // ICICI Bank
      'SBIUPI', 'SBIPSG', // SBI
      'HDFCBK', 'HDFCBN', // HDFC
      'AXISBK', 'AXISBN', // Axis
      'KOTAKB', // Kotak
      'PNBSMS', // PNB
      'BOIIND', // Bank of India
      'CANBNK', // Canara Bank
      'CENTBK', // Central Bank
      'IDBIBN', // IDBI
      'YESBNK', // Yes Bank
      'INDBNK', // Indian Bank
      'PAYTMB', // Paytm Payments Bank
      'SCBNK',  // Standard Chartered
      'CITIBN', // Citibank
      'HSBCIN', // HSBC
    ];

    return bankKeywords.any(
      (keyword) => sender.toUpperCase().contains(keyword),
    );
  }

  /// Parses SMS body using bank-specific regex patterns.
  static ParsedSmsTransaction? parse(String body, String sender) {
    try {
      final senderUpper = sender.toUpperCase();
      double? amount;
      bool isDebit = false;
      String? upiRef;
      String? accountRef;
      DateTime date = DateTime.now();
      String? payee;

      // ── ICICI Bank ──
      if (senderUpper.contains('ICICIT') ||
          senderUpper.contains('ICICIB')) {
        // ICICI Debit: "debited for Rs 949.81"
        final debitMatch = RegExp(
          r'debited for Rs\s*(\d+(?:,\d+)*(?:\.\d{1,2})?)',
        ).firstMatch(body);

        // ICICI Credit: "credited with Rs 200.00"
        final creditMatch = RegExp(
          r'credited with Rs\s*(\d+(?:,\d+)*(?:\.\d{1,2})?)',
        ).firstMatch(body);

        // ICICI NEFT/IMPS/RTGS Credit
        // Format: "credited:Rs. 25,000.00"
        final neftCreditMatch = RegExp(
          r'credited:Rs\.\s*(\d+(?:,\d+)*(?:\.\d{1,2})?)',
          caseSensitive: false,
        ).firstMatch(body);

        if (debitMatch != null) {
          amount = double.tryParse(debitMatch.group(1)!.replaceAll(',', ''));
          isDebit = true;
          // Payee: "PAYEE credited." after semicolon
          payee = RegExp(r';\s*(.+?)\s+credited\.')
              .firstMatch(body)
              ?.group(1);
        } else if (creditMatch != null) {
          amount = double.tryParse(creditMatch.group(1)!.replaceAll(',', ''));
          isDebit = false;
          // Sender name: "from NAME. UPI"
          payee = RegExp(r'from\s+([A-Z\s]+)\.\s+UPI')
              .firstMatch(body)
              ?.group(1)
              ?.trim();
        } else if (neftCreditMatch != null) {
          amount =
              double.tryParse(neftCreditMatch.group(1)!.replaceAll(',', ''));
          isDebit = false;

          // Extract NEFT/IMPS ref: "NEFT-HDFCH00899189473"
          final neftRefMatch = RegExp(
            r'(?:NEFT|IMPS|RTGS)-([A-Z0-9]+)',
            caseSensitive: false,
          ).firstMatch(body);
          upiRef = neftRefMatch?.group(0);

          // Extract info/payee after "Info "
          final infoMatch = RegExp(
            r'Info\s+(?:NEFT|IMPS|RTGS)-[A-Z0-9]+-(.+?)\.',
            caseSensitive: false,
          ).firstMatch(body);
          payee = infoMatch?.group(1)?.trim();
        }

        upiRef ??= RegExp(r'UPI:(\d+)').firstMatch(body)?.group(1);
        accountRef = RegExp(r'Acct\s+(XX?\d+)').firstMatch(body)?.group(1);

        final dateMatch = RegExp(
          r'on\s+(\d{2}-[A-Za-z]+-\d{2})',
        ).firstMatch(body);
        if (dateMatch != null) {
          try {
            date = DateFormat('dd-MMM-yy').parse(dateMatch.group(1)!);
          } catch (_) {}
        }

      // ── SBI ──
      } else if (senderUpper.contains('SBIUPI') ||
                 senderUpper.contains('SBIPSG')) {
        // SBI Debit: "debited by 274.34"
        final debitMatch = RegExp(
          r'debited by\s*(\d+(?:\.\d{1,2})?)',
        ).firstMatch(body);

        if (debitMatch != null) {
          amount = double.tryParse(debitMatch.group(1)!);
          isDebit = true;
          // Payee: "trf to PAYEE Refno"
          payee = RegExp(r'trf to\s+(.+?)\s+Refno')
              .firstMatch(body)
              ?.group(1)
              ?.trim();
        }

        upiRef = RegExp(r'Refno\s+(\d+)').firstMatch(body)?.group(1);
        accountRef = RegExp(r'A/C\s+(X\d+)').firstMatch(body)?.group(1);

        final dateMatch = RegExp(
          r'on date\s+(\d{2}[A-Za-z]+\d{2})',
        ).firstMatch(body);
        if (dateMatch != null) {
          try {
            date = DateFormat('ddMMMyy').parse(dateMatch.group(1)!);
          } catch (_) {}
        }

      // ── Generic fallback for other banks ──
      } else {
        final amountPatterns = [
          RegExp(r'(?:Rs\.?|INR|₹)\s*(\d+(?:,\d+)*(?:\.\d{1,2})?)', caseSensitive: false),
          RegExp(r'(\d+(?:,\d+)*(?:\.\d{1,2})?)\s*(?:Rs\.?|INR|₹)', caseSensitive: false),
        ];

        for (final pattern in amountPatterns) {
          final match = pattern.firstMatch(body);
          if (match != null) {
            final amountStr = match.group(1)!.replaceAll(',', '');
            amount = double.tryParse(amountStr);
            if (amount != null) break;
          }
        }

        final bodyLower = body.toLowerCase();
        isDebit = bodyLower.contains('debited') ||
            bodyLower.contains('debit') ||
            bodyLower.contains('withdrawn') ||
            bodyLower.contains('spent') ||
            bodyLower.contains('paid') ||
            bodyLower.contains('payment of');

        final isCredit = bodyLower.contains('credited') ||
            bodyLower.contains('credit') ||
            bodyLower.contains('received') ||
            bodyLower.contains('deposited');

        if (!isDebit && !isCredit) return null;

        final accountPattern = RegExp(
          r'[Aa]\/[Cc]\s*[xX*]+(\d{4})|account\s*[xX*]+(\d{4})',
          caseSensitive: false,
        );
        final accountMatch = accountPattern.firstMatch(body);
        accountRef = accountMatch?.group(1) ?? accountMatch?.group(2);

        final upiPattern = RegExp(
          r'(?:UPI|Ref\.?|Txn\.?)\s*(?:Ref\.?)?\s*[Nn]o\.?\s*:?\s*(\d{8,})',
          caseSensitive: false,
        );
        upiRef = upiPattern.firstMatch(body)?.group(1);
      }

      if (amount == null || amount <= 0) return null;

      // Use payee for smarter category detection
      final category = payee != null
          ? detectCategoryFromPayee(payee, body)
          : detectCategory(body);

      return ParsedSmsTransaction(
        amount: amount,
        isDebit: isDebit,
        date: date,
        last4Digits: accountRef,
        upiRef: upiRef,
        rawSms: body,
        detectedCategory: category,
        payeeName: payee,
      );
    } catch (_) {
      return null;
    }
  }

  /// Detects category from the extracted payee/merchant name.
  static String detectCategoryFromPayee(String payee, String body) {
    final p = payee.toUpperCase();

    // NEFT transfers are usually salary/income
    if (p.contains('NEFT') ||
        p.contains('SALARY') ||
        p.contains('PEPPER') ||
        p.contains('PAYROLL')) {
      return 'Income';
    }

    // Utility payments
    if (p.contains('AIRTEL') ||
        p.contains('JIO') ||
        p.contains('BSNL') ||
        p.contains('VI ') ||
        p.contains('ELECTRICITY') ||
        p.contains('BESCOM') ||
        p.contains('MSEB')) {
      return 'Bills';
    }
    // Food
    if (p.contains('ZOMATO') || p.contains('SWIGGY') ||
        p.contains('CAFE') || p.contains('RESTAURANT')) {
      return 'Food';
    }
    // Transport
    if (p.contains('UBER') || p.contains('OLA') ||
        p.contains('RAPIDO') || p.contains('METRO')) {
      return 'Transport';
    }
    // Shopping
    if (p.contains('AMAZON') || p.contains('FLIPKART') ||
        p.contains('MYNTRA') || p.contains('MEESHO')) {
      return 'Shopping';
    }
    // Entertainment
    if (p.contains('NETFLIX') || p.contains('SPOTIFY') ||
        p.contains('PRIME') || p.contains('HOTSTAR')) {
      return 'Entertainment';
    }
    // Peer transfer (person name pattern: two or more capitalized words)
    if (RegExp(r'^[A-Z]+\s+[A-Z]+').hasMatch(p)) {
      return 'Other';
    }
    return detectCategory(body);
  }

  /// Fallback category detection from raw SMS body keywords.
  static String detectCategory(String body) {
    final lower = body.toLowerCase();
    if (lower.contains('zomato') || lower.contains('swiggy') ||
        lower.contains('restaurant') || lower.contains('food') ||
        lower.contains('cafe') || lower.contains('hotel')) {
      return 'Food';
    }
    if (lower.contains('uber') || lower.contains('ola') ||
        lower.contains('metro') || lower.contains('petrol') ||
        lower.contains('fuel') || lower.contains('rapido')) {
      return 'Transport';
    }
    if (lower.contains('amazon') || lower.contains('flipkart') ||
        lower.contains('myntra') || lower.contains('shopping') ||
        lower.contains('mall')) {
      return 'Shopping';
    }
    if (lower.contains('electricity') || lower.contains('water bill') ||
        lower.contains('broadband') || lower.contains('recharge') ||
        lower.contains('airtel') || lower.contains('jio')) {
      return 'Bills';
    }
    if (lower.contains('salary') ||
        lower.contains('neft') ||
        lower.contains('imps') ||
        lower.contains('credited') ||
        lower.contains('transfer in')) {
      return 'Income';
    }
    if (lower.contains('netflix') || lower.contains('spotify') ||
        lower.contains('prime') || lower.contains('movie')) {
      return 'Entertainment';
    }
    return 'Other';
  }
}
