import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../application/ai_coach_notifier.dart';

class AiCoachBottomSheet extends ConsumerStatefulWidget {
  const AiCoachBottomSheet({super.key});

  @override
  ConsumerState<AiCoachBottomSheet> createState() => _AiCoachBottomSheetState();
}

class _AiCoachBottomSheetState extends ConsumerState<AiCoachBottomSheet> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  
  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppTheme>()!;
    final messages = ref.watch(aiCoachNotifierProvider);
    
    _scrollToBottom();
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(240),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          _buildHeader(context, theme),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return _buildMessageBubble(msg, theme);
              },
            ),
          ),
          _buildInputArea(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppTheme theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: theme.primary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Flo AI Coach',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => context.pop(),
          )
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg, AppTheme theme) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: msg.isUser ? theme.primary : theme.background,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: msg.isUser ? Radius.zero : const Radius.circular(16),
            bottomLeft: msg.isUser ? const Radius.circular(16) : Radius.zero,
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            color: msg.isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea(AppTheme theme) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Ask your AI coach...',
                filled: true,
                fillColor: theme.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: theme.primary,
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: _sendMessage,
            ),
          )
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _controller.text;
    if (text.trim().isNotEmpty) {
      ref.read(aiCoachNotifierProvider.notifier).sendMessage(text);
      _controller.clear();
    }
  }
}
