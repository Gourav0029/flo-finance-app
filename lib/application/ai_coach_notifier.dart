import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import './transactions_list_notifier.dart';

part 'ai_coach_notifier.g.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

@riverpod
class AiCoachNotifier extends _$AiCoachNotifier {
  late final GenerativeModel _model;

  @override
  List<ChatMessage> build() {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    print(
      'DEBUG - Gemini API Key Loaded: ${apiKey != null && apiKey.isNotEmpty} (Length: ${apiKey?.length ?? 0})',
    );

    if (apiKey == null || apiKey.isEmpty) {
      return [
        ChatMessage(
          text: "API Key missing! Please set GEMINI_API_KEY in .env.",
          isUser: false,
        ),
      ];
    }

    _model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);

    return [
      ChatMessage(
        text:
            "Hi! I'm your Flo AI Coach. Ask me how to optimize your spending or analyze your recent trends!",
        isUser: false,
      ),
    ];
  }

  Future<void> sendMessage(String query) async {
    if (query.trim().isEmpty) return;

    // Add user message
    state = [...state, ChatMessage(text: query, isUser: true)];

    try {
      // Gather context
      final txs = ref.read(transactionsListNotifierProvider);

      // Calculate simple bounds
      double income = 0;
      double expense = 0;
      Map<String, double> categorySums = {};

      for (var tx in txs) {
        if (tx.amount > 0) income += tx.amount;
        if (tx.amount < 0) {
          final amt = tx.amount.abs();
          expense += amt;
          categorySums[tx.category] = (categorySums[tx.category] ?? 0) + amt;
        }
      }

      final contextPrompt =
          """
You are Flo, a friendly, concise, and helpful financial AI coach in the 'Flo Finance' app.
Always reply with brief, actionable advice. Keep it under 4 paragraphs.
Format gracefully with basic markdown arrays or bold text if summarizing.
Context metrics for the user:
- Total Income: ₹$income
- Total Expenses: ₹$expense
- Net Balance: ₹${income - expense}
- Category Breakdown (Expenses only):
${categorySums.entries.map((e) => '  * ${e.key}: ₹${e.value}').join('\n')}

User Query: $query
""";

      final content = [Content.text(contextPrompt)];
      final response = await _model.generateContent(content);

      state = [
        ...state,
        ChatMessage(
          text: response.text ?? "I'm having trouble thinking right now.",
          isUser: false,
        ),
      ];
    } catch (e) {
      state = [
        ...state,
        ChatMessage(text: "Error communicating with AI: $e", isUser: false),
      ];
      print(e);
    }
  }
}
