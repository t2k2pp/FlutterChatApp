import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_app/app.dart';
import 'package:flutter_chat_app/data/datasources/local/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive初期化
  final dbService = DatabaseService();
  await dbService.initialize();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
