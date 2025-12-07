import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_app/domain/models/model_config.dart';
import 'package:flutter_chat_app/domain/enums/ai_provider.dart';
import 'package:flutter_chat_app/presentation/providers/settings_provider.dart';
import 'package:flutter_chat_app/core/theme/app_colors.dart';

/// モデル選択ウィジェット
class ModelSelector extends ConsumerWidget {
  final VoidCallback? onManageModels;

  const ModelSelector({
    super.key,
    this.onManageModels,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    return settingsAsync.when(
      data: (settings) {
        final activeModel = settings.models.firstWhere(
          (m) => m.id == settings.activeModelId,
          orElse: () => settings.models.first,
        );

        return PopupMenuButton<String>(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _getProviderIcon(activeModel.provider),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    activeModel.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, size: 18),
              ],
            ),
          ),
          itemBuilder: (context) {
            final items = settings.models.map((model) {
              return PopupMenuItem<String>(
                value: model.id,
                child: Row(
                  children: [
                    _getProviderIcon(model.provider),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(model.name),
                    ),
                    if (model.id == settings.activeModelId)
                      const Icon(Icons.check, size: 16, color: AppColors.primary),
                  ],
                ),
              );
            }).toList();

            // 区切り線とモデル管理ボタンを追加
            return [
              ...items,
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'manage',
                child: const Row(
                  children: [
                    Icon(Icons.settings, size: 16),
                    SizedBox(width: 12),
                    Text('モデルを管理'),
                  ],
                ),
              ),
            ];
          },
          onSelected: (value) {
            if (value == 'manage') {
              onManageModels?.call();
            } else {
              // モデルを変更
              final newSettings = settings.copyWith(activeModelId: value);
              ref.read(settingsProvider.notifier).updateSettings(newSettings);
            }
          },
        );
      },
      loading: () => const SizedBox(
        width: 100,
        height: 32,
        child: Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (_, __) => const Icon(Icons.error),
    );
  }

  Widget _getProviderIcon(AIProvider provider) {
    IconData icon;
    Color color;

    switch (provider) {
      case AIProvider.gemini:
        icon = Icons.auto_awesome;
        color = Colors.blue;
        break;
      case AIProvider.openaiCompatible:
        icon = Icons.chat;
        color = Colors.green;
        break;
      case AIProvider.azureOpenAI:
        icon = Icons.cloud;
        color = Colors.orange;
        break;
    }

    return Icon(icon, size: 16, color: color);
  }
}
