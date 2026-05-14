import 'package:ai_chat/ai_chat/data/repository/chat_upload_service.dart';
import 'package:ai_chat/ai_chat/presentation/screen/chat_screen.dart';
import 'package:ai_chat/core/config/config.dart';
import 'package:flutter/material.dart';
import 'package:thunder/thunder.dart';

class MangaAIApp extends StatefulWidget {
  const MangaAIApp({super.key});

  @override
  State<MangaAIApp> createState() => _MangaAIAppState();
}

class _MangaAIAppState extends State<MangaAIApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Assistant',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFAF0E6),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF0F8FF),
          brightness: Brightness.light,
          surface: const Color(0xFFFFFFFF),
        ),
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF090B14),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFAAC2DF),
          brightness: Brightness.dark,
          surface: const Color(0xFF111E3E),
        ),
        fontFamily: 'Roboto',
      ),
      builder: (context, child) {
        return Thunder(
          dio: [ChatUploadService.sharedDio],
          enabled: AppConfig.thunderEnabled,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const ChatScreen(),
    );
  }
}
