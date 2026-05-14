import 'dart:io';

import 'package:flutter/material.dart';

class SelectedImagePreview extends StatelessWidget {
  const SelectedImagePreview({
    super.key,
    required this.imagePath,
    required this.onRemove,
  });

  final String? imagePath;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: imagePath == null
          ? const SizedBox.shrink()
          : Container(
              key: const ValueKey('selected-image-preview'),
              margin: const EdgeInsets.only(bottom: 10),
              height: 88,
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 88,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(File(imagePath!), fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: onRemove,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: Color(0xCC000000),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
