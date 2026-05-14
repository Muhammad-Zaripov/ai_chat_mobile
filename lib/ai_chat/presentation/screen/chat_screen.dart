import 'package:ai_chat/ai_chat/data/model/chat_summary.dart';
import 'package:ai_chat/ai_chat/presentation/state/chat_screen_state.dart';
import 'package:ai_chat/ai_chat/presentation/widget/animated_message_bubble.dart';
import 'package:ai_chat/ai_chat/presentation/widget/assistant_loading_bubble.dart';
import 'package:ai_chat/ai_chat/presentation/widget/chat_app_bar.dart';
import 'package:ai_chat/ai_chat/presentation/widget/chat_colors.dart';
import 'package:ai_chat/ai_chat/presentation/widget/chat_composer.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ChatScreenState {
  @override
  Widget build(BuildContext context) {
    final colors = ChatColors.of(context);
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: colors.background,
        appBar: ChatAppBar(
          colors: colors,
          onNewChat: startNewChat,
          selectedChatId: selectedChatId,
          onDeleteChat: (id) => _confirmDelete(
            context,
            title: 'Chatni o‘chirish',
            content: 'Haqiqatan ham joriy chatni o‘chirmoqchimisiz?',
            onConfirm: () => deleteChat(id),
          ),
        ),
        drawer: _ChatHistoryDrawer(
          colors: colors,
          chats: chats,
          selectedChatId: selectedChatId,
          isLoading: isLoadingChats,
          onRefresh: loadChats,
          onNewChat: () {
            Navigator.of(context).pop();
            startNewChat();
          },
          onSelectChat: (chatId) {
            Navigator.of(context).pop();
            selectChat(chatId);
          },
          onDeleteAll: () {
            Navigator.of(context).pop();
            _confirmDelete(
              context,
              title: 'Barcha chatlarni o‘chirish',
              content: 'Haqiqatan ham barcha chatlarni o‘chirmoqchimisiz? Bu amalni ortga qaytarib bo‘lmaydi.',
              onConfirm: () => deleteAllChats(),
            );
          },
          onDeleteChat: (id) => _confirmDelete(
            context,
            title: 'Chatni o‘chirish',
            content: 'Haqiqatan ham bu chatni o‘chirmoqchimisiz?',
            onConfirm: () => deleteChat(id),
          ),
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          child: isLoadingMessages
              ? Center(
                  key: const ValueKey('message-loading'),
                  child: CircularProgressIndicator(color: colors.primary),
                )
              : messages.isEmpty && !isSendingMessage
              ? _EmptyChat(colors: colors)
              : ListView.builder(
                  key: const ValueKey('message-list'),
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  itemCount: messages.length + (isSendingMessage ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == messages.length) {
                      return AssistantLoadingBubble(
                        key: const ValueKey('assistant-loading'),
                        colors: colors,
                      );
                    }

                    final message = messages[index];
                    return AnimatedMessageBubble(
                      key: ValueKey(message.id),
                      message: message,
                      colors: colors,
                    );
                  },
                ),
        ),
        bottomNavigationBar: AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: keyboardInset),
          child: ChatComposer(
            colors: colors,
            controller: messageController,
            canSend: canSend,
            onSend: sendMessage,
          ),
        ),
      ),
    );
  }

  void _confirmDelete(
    BuildContext context, {
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Bekor qilish'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: const Text('O‘chirish', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _ChatHistoryDrawer extends StatelessWidget {
  const _ChatHistoryDrawer({
    required this.colors,
    required this.chats,
    required this.selectedChatId,
    required this.isLoading,
    required this.onRefresh,
    required this.onNewChat,
    required this.onSelectChat,
    required this.onDeleteAll,
    required this.onDeleteChat,
  });

  final ChatColors colors;
  final List<ChatSummary> chats;
  final String? selectedChatId;
  final bool isLoading;
  final VoidCallback onRefresh;
  final VoidCallback onNewChat;
  final ValueChanged<String> onSelectChat;
  final VoidCallback onDeleteAll;
  final ValueChanged<String> onDeleteChat;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: colors.surface,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Chatlar',
                      style: TextStyle(
                        color: colors.title,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Yangilash',
                    onPressed: onRefresh,
                    icon: Icon(Icons.refresh, color: colors.icon),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onNewChat,
                  icon: const Icon(Icons.add),
                  label: const Text('Yangi chat'),
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (isLoading)
              LinearProgressIndicator(
                minHeight: 2,
                color: colors.primary,
                backgroundColor: colors.input,
              ),
            Expanded(
              child: chats.isEmpty
                  ? Center(
                      child: Text(
                        'Hali chat yo‘q',
                        style: TextStyle(color: colors.mutedText),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(8),
                      itemCount: chats.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 4),
                      itemBuilder: (context, index) {
                        final chat = chats[index];
                        final isSelected = chat.id == selectedChatId;
                        return ListTile(
                          selected: isSelected,
                          selectedTileColor: colors.input,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          leading: Icon(
                            Icons.chat_bubble_outline,
                            color: isSelected ? colors.primary : colors.icon,
                          ),
                          title: Text(
                            chat.displayTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colors.text,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            _formatChatDate(chat.updatedAt),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: colors.mutedText),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete_outline, color: colors.icon),
                            onPressed: () => onDeleteChat(chat.id),
                          ),
                          onTap: () => onSelectChat(chat.id),
                        );
                      },
                    ),
            ),
            if (chats.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    onPressed: onDeleteAll,
                    icon: const Icon(Icons.delete_forever),
                    label: const Text('Barcha chatlarni o‘chirish'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatChatDate(DateTime date) {
    final local = date.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$day.$month $hour:$minute';
  }
}

class _EmptyChat extends StatelessWidget {
  const _EmptyChat({required this.colors});

  final ChatColors colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const ValueKey('empty-chat'),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Xabar yozing yoki chap menyudan eski chatni tanlang',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colors.mutedText,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
