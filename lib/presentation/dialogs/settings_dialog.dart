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
  late TextEditingController _searchBaseUrlController;
  bool _searchBaseUrlInitialized = false;

  @override
  void dispose() {
    _searchBaseUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 600;

    return Dialog(
      insetPadding: EdgeInsets.all(isMobile ? 16 : 40),
      child: Container(
        width: isMobile ? double.infinity : 800,
        height: isMobile ? screenHeight * 0.85 : 600,
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
              child: isMobile
                  ? Column(
                      children: [
                        // タブナビゲーション（横並び）
                        _buildMobileTabNavigation(),
                        // タブコンテンツ
                        Expanded(
                          child: settingsAsync.when(
                            data: (settings) => _buildTabContent(settings),
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (error, _) => Center(child: Text('エラー: $error')),
                          ),
                        ),
                      ],
                    )
                  : Row(
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
  
  Widget _buildMobileTabNavigation() {
    final tabs = [
      {'icon': Icons.auto_awesome, 'label': 'モデル'},
      {'icon': Icons.search, 'label': '検索'},
      {'icon': Icons.psychology, 'label': 'Watson'},
      {'icon': Icons.volume_up, 'label': 'TTS'},
    ];

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = _selectedTab == index;

          return Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedTab = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tab['icon'] as IconData,
                      size: 20,
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tab['label'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
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
                  // 削除ボタン（最後の1件は削除不可）
                  if (settings.models.length > 1)
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _deleteModel(settings, model),
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
    // コントローラーを1度だけ初期化
    if (!_searchBaseUrlInitialized) {
      _searchBaseUrlController = TextEditingController(text: settings.search.baseUrl);
      _searchBaseUrlInitialized = true;
    }

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
            controller: _searchBaseUrlController,
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
        
        // Watson用AIモデル選択
        const Text(
          'Watson用AIモデル',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Builder(
          builder: (context) {
            // subModelIdが有効かチェック
            final validSubModelId = settings.models.any((m) => m.id == settings.subModelId)
                ? settings.subModelId
                : (settings.models.isNotEmpty ? settings.models.first.id : null);
            
            return DropdownButtonFormField<String>(
              value: validSubModelId,
              decoration: const InputDecoration(
                hintText: 'Watsonが使用するモデルを選択',
              ),
              items: settings.models.map((model) {
                return DropdownMenuItem(
                  value: model.id,
                  child: Text(model.name),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  final newSettings = settings.copyWith(subModelId: value);
                  ref.read(settingsProvider.notifier).updateSettings(newSettings);
                }
              },
            );
          },
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

  void _deleteModel(UserSettings settings, ModelConfig model) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('モデルを削除'),
        content: Text('「${model.name}」を削除してもよろしいですか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              final newModels = settings.models
                  .where((m) => m.id != model.id)
                  .toList();
              
              // アクティブモデルが削除された場合、最初のモデルをアクティブに
              String newActiveId = settings.activeModelId;
              if (model.id == settings.activeModelId && newModels.isNotEmpty) {
                newActiveId = newModels.first.id;
              }
              
              // サブモデル（Watson用）が削除された場合も更新
              String newSubModelId = settings.subModelId;
              if (model.id == settings.subModelId && newModels.isNotEmpty) {
                newSubModelId = newModels.first.id;
              }
              
              final newSettings = settings.copyWith(
                models: List<ModelConfig>.from(newModels),
                activeModelId: newActiveId,
                subModelId: newSubModelId,
              );
              ref.read(settingsProvider.notifier).updateSettings(newSettings);
              Navigator.pop(context);
            },
            child: const Text('削除', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
