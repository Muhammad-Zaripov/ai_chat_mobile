import 'package:ai_chat/ai_chat/data/repository/ai_chat_backend_service.dart';
import 'package:ai_chat/ai_chat/data/model/chat_summary.dart';
import 'package:ai_chat/ai_chat/domain/models/chat_message.dart';
import 'package:ai_chat/ai_chat/presentation/screen/chat_screen.dart';
import 'package:flutter/material.dart';

abstract class ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final AiChatBackendService aiChatService = AiChatBackendService();

  final List<ChatMessage> messages = <ChatMessage>[];
  final List<ChatSummary> chats = <ChatSummary>[];

  String? selectedChatId;
  bool isLoadingChats = false;
  bool isLoadingMessages = false;
  bool isSendingMessage = false;

  bool get canSend =>
      !isSendingMessage && messageController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    messageController.addListener(_onMessageChanged);
    loadChats();
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

  Future<void> loadChats() async {
    if (isLoadingChats) return;

    setState(() => isLoadingChats = true);
    try {
      final items = await aiChatService.listChats();
      if (!mounted) return;

      setState(() {
        chats
          ..clear()
          ..addAll(items);
        selectedChatId ??= items.isEmpty ? null : items.first.id;
      });

      if (selectedChatId != null && messages.isEmpty) {
        await selectChat(selectedChatId!);
      }
    } catch (error) {
      if (mounted) _showSnackBar('Chatlar yuklanmadi: $error');
    } finally {
      if (mounted) setState(() => isLoadingChats = false);
    }
  }

  Future<void> selectChat(String chatId) async {
    final id = chatId.trim();
    if (id.isEmpty || isLoadingMessages) return;

    setState(() {
      selectedChatId = id;
      aiChatService.currentChatId = id;
      messages.clear();
      isLoadingMessages = true;
    });

    try {
      final items = await aiChatService.listMessages(id);
      if (!mounted) return;
      setState(() {
        messages
          ..clear()
          ..addAll(items);
      });
      _scrollToBottom();
    } catch (error) {
      if (mounted) _showSnackBar('Chat history yuklanmadi: $error');
    } finally {
      if (mounted) setState(() => isLoadingMessages = false);
    }
  }

  Future<void> startNewChat() async {
    if (isSendingMessage || isLoadingMessages) return;

    setState(() {
      messages.clear();
      isLoadingMessages = true;
    });

    try {
      final chatId = await aiChatService.createChat();
      if (!mounted) return;
      setState(() {
        selectedChatId = chatId;
        messages.clear();
      });
      await refreshChatsSilently();
    } catch (error) {
      if (mounted) _showSnackBar('Yangi chat ochilmadi: $error');
    } finally {
      if (mounted) setState(() => isLoadingMessages = false);
    }
  }

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
      setState(() => selectedChatId = aiChatService.currentChatId);
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
      await refreshChatsSilently();
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

  Future<void> refreshChatsSilently() async {
    try {
      final items = await aiChatService.listChats();
      if (!mounted) return;
      setState(() {
        chats
          ..clear()
          ..addAll(items);
      });
    } catch (_) {
      // Chat history is a nice-to-have refresh after send; keep conversation usable.
    }
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
