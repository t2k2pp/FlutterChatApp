import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_app/domain/models/chat_session.dart';
import 'package:flutter_chat_app/data/datasources/local/database_service.dart';
import 'package:flutter_chat_app/presentation/providers/settings_provider.dart';

/// Sessions State Notifier
class SessionsNotifier extends StateNotifier<AsyncValue<List<ChatSession>>> {
  final DatabaseService _dbService;

  SessionsNotifier(this._dbService) : super(const AsyncValue.loading()) {
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    try {
      final sessions = await _dbService.getSessions();
      state = AsyncValue.data(sessions);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> saveSession(ChatSession session) async {
    try {
      await _dbService.saveSession(session);
      await _loadSessions();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteSession(String sessionId) async {
    try {
      await _dbService.deleteSession(sessionId);
      await _loadSessions();
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> reload() async {
    await _loadSessions();
  }
}

/// Sessions Provider
final sessionsProvider =
    StateNotifierProvider<SessionsNotifier, AsyncValue<List<ChatSession>>>((ref) {
  final dbService = ref.watch(databaseServiceProvider);
  return SessionsNotifier(dbService);
});

/// Current Session ID Provider
final currentSessionIdProvider = StateProvider<String?>((ref) => null);

/// Current Session Provider（現在選択中のセッション）
final currentSessionProvider = Provider<ChatSession?>((ref) {
  final sessionId = ref.watch(currentSessionIdProvider);
  final sessionsAsync = ref.watch(sessionsProvider);

  return sessionsAsync.whenOrNull(
    data: (sessions) {
      if (sessionId == null) return null;
      return sessions.firstWhere(
        (s) => s.id == sessionId,
        orElse: () => sessions.isNotEmpty ? sessions.first : null as ChatSession,
      );
    },
  );
});
