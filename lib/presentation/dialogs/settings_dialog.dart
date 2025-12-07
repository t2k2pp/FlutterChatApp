import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_app/domain/models/user_settings.dart';
import 'package:flutter_chat_app/domain/models/model_config.dart';
import 'package:flutter_chat_app/domain/enums/ai_provider.dart';
import 'package:flutter_chat_app/domain/enums/watson_intervention_level.dart';
import 'package:flutter_chat_app/presentation/providers/settings_provider.dart';
import 'package:flutter_chat_app/presentation/dialogs/model_edit_dialog.dart';
import 'package:flutter_chat_app/core/theme/app_colors.dart';
import 'package:flutter_chat_app/core/utils/id_generator.dart';
import 'package:flutter_chat_app/core/constants/app_constants.dart';

/// 設定ダイアログ（簡易版）
class SettingsDialog extends ConsumerStatefulWidget {
  const SettingsDialog({super.key});

  @override
  ConsumerState<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends ConsumerState<SettingsDialog> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);

    return Dialog(
      child: Container(
        width: 800,
        height: 600,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          children: [
            // ヘッダー
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.border),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    '設定',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // 本体
            Expanded(
              child: Row(
                children: [
                  // タブナビゲーション
                  _buildTabNavigation(),

                  // タブコンテンツ
                  Expanded(
                    child: settingsAsync.when(
                      data: (settings) => _buildTabContent(settings),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, _) => Center(child: Text('エラー: $error')),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabNavigation() {
    final tabs = [
      {'icon': Icons.auto_awesome, 'label': 'モデル'},
      {'icon': Icons.search, 'label': '検索'},
      {'icon': Icons.psychology, 'label': 'Watson'},
      {'icon': Icons.volume_up, 'label': 'TTS'},
    ];

    return Container(
      width: 200,
      decoration: const BoxDecoration(
        color: AppColors.surfaceAlt,
        border: Border(
          right: BorderSide(color: AppColors.border),
        ),
      ),
      child: ListView.builder(
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final tab = tabs[index];
          final isSelected = _selectedTab == index;

          return ListTile(
            leading: Icon(
              tab['icon'] as IconData,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
            title: Text(
              tab['label'] as String,
              style: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            selected: isSelected,
            selectedTileColor: Colors.white.withOpacity(0.5),
            onTap: () {
              setState(() {
                _selectedTab = index;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildTabContent(UserSettings settings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: switch (_selectedTab) {
        0 => _buildModelsTab(settings),
        1 => _buildSearchTab(settings),
        2 => _buildWatsonTab(settings),
        3 => _buildTTSTab(settings),
        _ => const SizedBox(),
      },
    );
  }

  Widget _buildModelsTab(UserSettings settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'AIモデル',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...settings.models.map((model) {
          final isActive = model.id == settings.activeModelId;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: _getProviderIcon(model.provider),
              title: Text(model.name),
              subtitle: Text('${model.provider.value} - ${model.modelId}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isActive)
                    const Chip(
                      label: Text('アクティブ', style: TextStyle(fontSize: 12)),
                      backgroundColor: AppColors.primaryLight,
                    ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ModelEditDialog(
                          existingModel: model,
                          settings: settings,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => ModelEditDialog(
                existingModel: null,
                settings: settings,
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('モデルを追加'),
        ),
      ],
    );
  }

  Widget _buildSearchTab(UserSettings settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Web検索設定',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Web検索を有効化'),
          value: settings.search.enabled,
          onChanged: (value) {
            final newSettings = settings.copyWith(
              search: settings.search.copyWith(enabled: value),
            );
            ref.read(settingsProvider.notifier).updateSettings(newSettings);
          },
        ),
        if (settings.search.enabled) ...[
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'SearXNG  Base URL',
              hintText: 'http://localhost:8080',
            ),
            controller: TextEditingController(text: settings.search.baseUrl),
            onChanged: (value) {
              final newSettings = settings.copyWith(
                search: settings.search.copyWith(baseUrl: value),
              );
              ref.read(settingsProvider.notifier).updateSettings(newSettings);
            },
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Deep Researchを有効化'),
            subtitle: const Text('反復的な深い調査'),
            value: settings.search.deepResearchEnabled,
            onChanged: (value) {
              final newSettings = settings.copyWith(
                search: settings.search.copyWith(deepResearchEnabled: value),
              );
              ref.read(settingsProvider.notifier).updateSettings(newSettings);
            },
          ),
        ],
      ],
    );
  }

  Widget _buildWatsonTab(UserSettings settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Watson Observer設定',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Watsonは会話を観察し、必要に応じて介入するセカンダリAIです。',
          style: TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          '介入レベル',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ...WatsonInterventionLevel.values.map((level) {
          return RadioListTile<WatsonInterventionLevel>(
            title: Text(level.label),
            subtitle: Text(_getWatsonLevelDescription(level)),
            value: level,
            groupValue: settings.watsonInterventionLevel,
            onChanged: (value) {
              if (value != null) {
                final newSettings = settings.copyWith(
                  watsonInterventionLevel: value,
                );
                ref.read(settingsProvider.notifier).updateSettings(newSettings);
              }
            },
          );
        }),
      ],
    );
  }

  Widget _buildTTSTab(UserSettings settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Text-to-Speech設定',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        const Text('読み上げ速度'),
        Slider(
          value: settings.tts.speed,
          min: 0.5,
          max: 2.0,
          divisions: 15,
          label: settings.tts.speed.toStringAsFixed(1),
          onChanged: (value) {
            final newSettings = settings.copyWith(
              tts: settings.tts.copyWith(speed: value),
            );
            ref.read(settingsProvider.notifier).updateSettings(newSettings);
          },
        ),
        Text('${settings.tts.speed.toStringAsFixed(1)}x'),
      ],
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

    return Icon(icon, color: color);
  }

  String _getWatsonLevelDescription(WatsonInterventionLevel level) {
    switch (level) {
      case WatsonInterventionLevel.low:
        return '事実エラーまたは安全リスクのみ介入';
      case WatsonInterventionLevel.medium:
        return '適度なバランスで介入';
      case WatsonInterventionLevel.high:
        return '積極的に介入し、詳細にチェック';
    }
  }
}
