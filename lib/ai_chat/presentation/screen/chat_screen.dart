import 'package:ai_chat/ai_chat/presentation/state/chat_screen_state.dart';
import 'package:ai_chat/ai_chat/presentation/widget/animated_message_bubble.dart';
import 'package:ai_chat/ai_chat/presentation/widget/assistant_loading_bubble.dart';
import 'package:ai_chat/ai_chat/presentation/widget/attachment_bottom_sheet.dart';
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
        appBar: ChatAppBar(colors: colors),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          child: ListView.builder(
            key: const ValueKey('message-list'),
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
            pickedImage: pickedImage?.path,
            canSend: canSend,
            isPickingImage:
                isPickingImage || isUploadingFile || isSendingMessage,
            onAttachmentTap: () => _showAttachmentSheet(context, colors),
            onRemoveImage: removePickedImage,
            onSend: sendMessage,
          ),
        ),
      ),
    );
  }

  Future<void> _showAttachmentSheet(
    BuildContext context,
    ChatColors colors,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: colors.surface,
      barrierColor: Colors.black.withValues(alpha: 0.24),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return AttachmentBottomSheet(
          colors: colors,
          onPickImage: () {
            Navigator.of(sheetContext).pop();
            pickImageFromGallery();
          },
          onCamera: () {
            Navigator.of(sheetContext).pop();
            pickImageFromCamera();
          },
          onFile: () {
            Navigator.of(sheetContext).pop();
            pickFile();
          },
        );
      },
    );
  }
}
