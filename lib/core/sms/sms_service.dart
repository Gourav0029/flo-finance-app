import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'sms_parser.dart';

/// Handles reading SMS from device using flutter_sms_inbox.
/// All SMS processing is local — no data ever leaves the device.
class SmsService {
  static final SmsQuery _query = SmsQuery();

  static Future<bool> requestPermission() async {
    final status = await Permission.sms.request();
    return status.isGranted;
  }

  static Future<bool> hasPermission() async {
    return await Permission.sms.isGranted;
  }

  /// Fetches bank SMS from the last 30 days and parses them.
  static Future<List<ParsedSmsTransaction>> fetchBankSms() async {
    try {
      final messages = await _query.querySms(
        kinds: [SmsQueryKind.inbox],
      );

      final cutoff = DateTime.now().subtract(const Duration(days: 30));

      final results = <ParsedSmsTransaction>[];
      for (final message in messages) {
        final sender = message.sender ?? '';
        final body = message.body ?? '';
        final date = message.date;

        if (date != null && date.isBefore(cutoff)) continue;

        if (SmsParser.isBankSms(sender)) {
          final parsed = SmsParser.parse(body, sender);
          if (parsed != null) results.add(parsed);
        }
      }
      return results;
    } catch (_) {
      return [];
    }
  }
}
