import 'package:ai_chat/ai_chat/data/repository/ai_chat_backend_service.dart';
import 'package:ai_chat/ai_chat/domain/models/chat_message.dart';
import 'package:ai_chat/ai_chat/presentation/screen/chat_screen.dart';
import 'package:flutter/material.dart';

abstract class ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final AiChatBackendService aiChatService = AiChatBackendService();

  final List<ChatMessage> messages = <ChatMessage>[];

  bool isSendingMessage = false;

  bool get canSend =>
      !isSendingMessage && messageController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    messageController.addListener(_onMessageChanged);
  }

  @override
  void dispose() {
    messageController
      ..removeListener(_onMessageChanged)
      ..dispose();
    scrollController.dispose();
    super.dispose();
  }

  void _onMessageChanged() => setState(() {});

  Future<void> sendMessage() async {
    if (isSendingMessage) return;

    final text = messageController.text.trim();
    if (text.isEmpty) return;

    final userMessage = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      text: text,
    );

    setState(() {
      messages.add(userMessage);
      messageController.clear();
      isSendingMessage = true;
    });

    _scrollToBottom();

    try {
      final reply = await aiChatService.sendMessage(text: text);
      if (!mounted) return;
      if (reply.trim().isEmpty) return;

      setState(() {
        messages.add(
          ChatMessage(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            createdAt: DateTime.now(),
            text: reply.trim(),
            isMine: false,
          ),
        );
      });
      _scrollToBottom();
    } catch (error) {
      if (!mounted) return;
      final message = 'AI chat javob bermadi: $error';
      _showSnackBar(message);
      setState(() {
        messages.add(
          ChatMessage(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            createdAt: DateTime.now(),
            text: message,
            isMine: false,
          ),
        );
      });
      _scrollToBottom();
    } finally {
      if (mounted) {
        setState(() => isSendingMessage = false);
      }
    }
  }

  Future<void> sendSuggestionMessage(String text) async {
    messageController.text = text;
    await sendMessage();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeOutCubic,
      );
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
