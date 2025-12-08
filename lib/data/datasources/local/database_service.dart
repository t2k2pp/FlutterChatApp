import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_chat_app/domain/models/chat_session.dart';
import 'package:flutter_chat_app/domain/models/user_settings.dart';
import 'package:flutter_chat_app/domain/models/model_usage_stats.dart';
import 'package:flutter_chat_app/domain/models/token_usage.dart';
import 'package:flutter_chat_app/core/constants/app_constants.dart';

/// LinkedMapをMap<String, dynamic>に再帰的に変換
dynamic _deepConvert(dynamic value) {
  if (value is Map) {
    return Map<String, dynamic>.fromEntries(
      value.entries.map((e) => MapEntry(e.key.toString(), _deepConvert(e.value))),
    );
  } else if (value is List) {
    return value.map((e) => _deepConvert(e)).toList();
  }
  return value;
}

class DatabaseService {
  static const String _settingsBox = 'settings';
  static const String _sessionsBox = 'sessions';
  static const String _usageBox = 'model_usage';
  static const String _settingsKey = 'user_settings';

  /// Hiveの初期化
  Future<void> initialize() async {
    await Hive.initFlutter();
    
    // Boxを開く
    await Hive.openBox(_settingsBox);
    await Hive.openBox(_sessionsBox);
    await Hive.openBox(_usageBox);
  }

  /// 設定を取得
  Future<UserSettings> getSettings() async {
    final box = Hive.box(_settingsBox);
    final data = box.get(_settingsKey);
    
    if (data == null) {
      return defaultSettings;
    }
    
    try {
      return UserSettings.fromJson(_deepConvert(data) as Map<String, dynamic>);
    } catch (e) {
      print('設定の読み込みエラー: $e');
      return defaultSettings;
    }
  }

  /// 設定を保存
  Future<void> saveSettings(UserSettings settings) async {
    final box = Hive.box(_settingsBox);
    await box.put(_settingsKey, settings.toJson());
  }

  /// セッション一覧を取得（更新日時順）
  Future<List<ChatSession>> getSessions() async {
    final box = Hive.box(_sessionsBox);
    final List<ChatSession> sessions = [];
    
    for (var key in box.keys) {
      try {
        final data = box.get(key);
        if (data != null) {
          final session = ChatSession.fromJson(_deepConvert(data) as Map<String, dynamic>);
          sessions.add(session);
        }
      } catch (e) {
        print('セッション読み込みエラー (key: $key): $e');
      }
    }
    
    // 更新日時でソート（新しい順）
    sessions.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return sessions;
  }

  /// セッションを保存
  Future<void> saveSession(ChatSession session) async {
    final box = Hive.box(_sessionsBox);
    await box.put(session.id, session.toJson());
  }

  /// セッションを削除
  Future<void> deleteSession(String sessionId) async {
    final box = Hive.box(_sessionsBox);
    await box.delete(sessionId);
  }

  /// モデル使用量を更新
  Future<void> updateModelUsage(String modelId, TokenUsage usage) async {
    final box = Hive.box(_usageBox);
    
    final existingData = box.get(modelId);
    ModelUsageStats stats;
    
    if (existingData == null) {
      stats = ModelUsageStats(
        modelId: modelId,
        totalPromptTokens: usage.promptTokens,
        totalCompletionTokens: usage.completionTokens,
        totalTokens: usage.totalTokens,
      );
    } else {
      try {
        final existing = ModelUsageStats.fromJson(
          Map<String, dynamic>.from(existingData),
        );
        stats = ModelUsageStats(
          modelId: modelId,
          totalPromptTokens: existing.totalPromptTokens + usage.promptTokens,
          totalCompletionTokens: existing.totalCompletionTokens + usage.completionTokens,
          totalTokens: existing.totalTokens + usage.totalTokens,
        );
      } catch (e) {
        print('使用量統計の読み込みエラー: $e');
        stats = ModelUsageStats(
          modelId: modelId,
          totalPromptTokens: usage.promptTokens,
          totalCompletionTokens: usage.completionTokens,
          totalTokens: usage.totalTokens,
        );
      }
    }
    
    await box.put(modelId, stats.toJson());
  }

  /// モデル使用量統計を取得
  Future<List<ModelUsageStats>> getModelUsageStats() async {
    final box = Hive.box(_usageBox);
    final List<ModelUsageStats> stats = [];
    
    for (var key in box.keys) {
      try {
        final data = box.get(key);
        if (data != null) {
          final stat = ModelUsageStats.fromJson(Map<String, dynamic>.from(data));
          stats.add(stat);
        }
      } catch (e) {
        print('使用量統計の読み込みエラー (key: $key): $e');
      }
    }
    
    return stats;
  }

  /// すべてのデータをクリア（テスト用）
  Future<void> clearAll() async {
    await Hive.box(_settingsBox).clear();
    await Hive.box(_sessionsBox).clear();
    await Hive.box(_usageBox).clear();
  }
}
