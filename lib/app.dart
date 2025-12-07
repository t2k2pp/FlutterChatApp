import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/theme/app_theme.dart';
import 'package:flutter_chat_app/presentation/screens/chat_screen.dart';

/// メインアプリケーションウィジェット
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi GenAI Chat',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const ChatScreen(),
    );
  }
}
