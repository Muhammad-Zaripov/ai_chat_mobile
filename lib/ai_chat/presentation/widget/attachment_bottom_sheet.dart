import 'package:ai_chat/ai_chat/presentation/widget/chat_colors.dart';
import 'package:flutter/material.dart';

class AttachmentBottomSheet extends StatelessWidget {
  const AttachmentBottomSheet({
    super.key,
    required this.colors,
    required this.onPickImage,
    required this.onCamera,
    required this.onFile,
  });

  final ChatColors colors;
  final VoidCallback onPickImage;
  final VoidCallback onCamera;
  final VoidCallback onFile;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: colors.inputBorder,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 18),
            _AttachmentTile(
              colors: colors,
              icon: Icons.photo_library_rounded,
              title: 'Pick image',
              onTap: onPickImage,
            ),
            const SizedBox(height: 10),
            _AttachmentTile(
              colors: colors,
              icon: Icons.photo_camera_rounded,
              title: 'Camera',
              onTap: onCamera,
            ),
            const SizedBox(height: 10),
            _AttachmentTile(
              colors: colors,
              icon: Icons.insert_drive_file_rounded,
              title: 'File',
              onTap: onFile,
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  const _AttachmentTile({
    required this.colors,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final ChatColors colors;
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.input,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colors.iconButton,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: colors.icon, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: colors.title,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: colors.mutedText),
            ],
          ),
        ),
      ),
    );
  }
}
