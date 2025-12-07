import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_app/domain/models/user_settings.dart';
import 'package:flutter_chat_app/data/datasources/local/database_service.dart';
import 'package:flutter_chat_app/core/constants/app_constants.dart';

/// DatabaseServiceのProvider
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

/// Settings State Notifier
class SettingsNotifier extends StateNotifier<AsyncValue<UserSettings>> {
  final DatabaseService _dbService;

  SettingsNotifier(this._dbService) : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await _dbService.getSettings();
      state = AsyncValue.data(settings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateSettings(UserSettings settings) async {
    try {
      await _dbService.saveSettings(settings);
      state = AsyncValue.data(settings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> reload() async {
    await _loadSettings();
  }
}

/// Settings Provider
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AsyncValue<UserSettings>>((ref) {
  final dbService = ref.watch(databaseServiceProvider);
  return SettingsNotifier(dbService);
});
