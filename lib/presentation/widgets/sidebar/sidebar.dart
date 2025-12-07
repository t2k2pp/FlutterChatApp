import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_app/domain/models/chat_session.dart';
import 'package:flutter_chat_app/domain/models/project.dart';
import 'package:flutter_chat_app/core/theme/app_colors.dart';
import 'package:flutter_chat_app/presentation/providers/sessions_provider.dart';
import 'package:flutter_chat_app/presentation/providers/settings_provider.dart';
import 'package:flutter_chat_app/core/utils/id_generator.dart';

/// サイドバーウィジェット
class Sidebar extends ConsumerWidget {
  final bool isOpen;
  final VoidCallback onClose;
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenProjects;

  const Sidebar({
    super.key,
    required this.isOpen,
    required this.onClose,
    required this.onOpenSettings,
    required this.onOpenProjects,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsAsync = ref.watch(sessionsProvider);
    final currentSessionId = ref.watch(currentSessionIdProvider);
    final settingsAsync = ref.watch(settingsProvider);

    // TODO: アクティブプロジェクトIDの管理
    final activeProjectId = null;

    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: Color(0xFFF0EFEA),
        border: Border(
          right: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        children: [
          // ヘッダー
          _buildHeader(context, activeProjectId, settingsAsync.asData?.value.projects),

          // 新規チャットボタン
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () => _createNewSession(ref),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('新規チャット'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 44),
                backgroundColor: Colors.white,
                foregroundColor: AppColors.textPrimary,
                elevation: 0,
                side: const BorderSide(color: AppColors.border),
              ),
            ),
          ),

          // セッション一覧
          Expanded(
            child: sessionsAsync.when(
              data: (sessions) {
                if (sessions.isEmpty) {
                  return const Center(
                    child: Text(
                      '履歴なし',
                      style: TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 14,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    final isSelected = session.id == currentSessionId;

                    return _SessionListItem(
                      session: session,
                      isSelected: isSelected,
                      onTap: () {
                        ref.read(currentSessionIdProvider.notifier).state = session.id;
                        // メッセージをロード
                        // TODO: ChatProviderにロード機能を追加
                      },
                      onDelete: () => _deleteSession(ref, session.id),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text('エラー: $error'),
              ),
            ),
          ),

          // フッター
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String? activeProjectId, List<Project>? projects) {
    // アクティブプロジェクトを取得
    final activeProject = activeProjectId != null
        ? projects?.firstWhere((p) => p.id == activeProjectId, orElse: () => null as Project)
        : null;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onOpenProjects,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      activeProjectId != null ? Icons.folder : Icons.auto_awesome,
                      size: 16,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        activeProject?.name ?? 'General Chat',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(Icons.expand_more, size: 16),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: onClose,
            tooltip: 'サイドバーを閉じる',
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: InkWell(
        onTap: onOpenSettings,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: const Row(
            children: [
              Icon(Icons.settings, size: 18),
              SizedBox(width: 12),
              Text(
                '設定',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createNewSession(WidgetRef ref) {
    final newSessionId = IdGenerator.generate();
    final newSession = ChatSession(
      id: newSessionId,
      title: '新規チャット',
      messages: const [],
      updatedAt: DateTime.now().millisecondsSinceEpoch,
    );

    ref.read(sessionsProvider.notifier).saveSession(newSession);
    ref.read(currentSessionIdProvider.notifier).state = newSessionId;
  }

  void _deleteSession(WidgetRef ref, String sessionId) {
    ref.read(sessionsProvider.notifier).deleteSession(sessionId);
  }
}

/// セッションリストアイテム
class _SessionListItem extends StatefulWidget {
  final ChatSession session;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _SessionListItem({
    required this.session,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
  });

  @override
  State<_SessionListItem> createState() => _SessionListItemState();
}

class _SessionListItemState extends State<_SessionListItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: widget.isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: widget.isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                  ),
                ]
              : null,
        ),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.session.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: widget.isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_isHovered)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 16),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('チャットを削除'),
                          content: const Text('このチャットを削除してもよろしいですか？'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('キャンセル'),
                            ),
                            TextButton(
                              onPressed: () {
                                widget.onDelete();
                                Navigator.pop(context);
                              },
                              child: const Text('削除'),
                            ),
                          ],
                        ),
                      );
                    },
                    tooltip: '削除',
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
