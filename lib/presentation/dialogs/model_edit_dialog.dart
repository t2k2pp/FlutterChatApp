import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_app/domain/models/model_config.dart';
import 'package:flutter_chat_app/domain/models/user_settings.dart';
import 'package:flutter_chat_app/domain/enums/ai_provider.dart';
import 'package:flutter_chat_app/presentation/providers/settings_provider.dart';
import 'package:flutter_chat_app/core/theme/app_colors.dart';
import 'package:flutter_chat_app/core/utils/id_generator.dart';

/// モデル追加/編集ダイアログ
class ModelEditDialog extends ConsumerStatefulWidget {
  final ModelConfig? existingModel;
  final UserSettings settings;

  const ModelEditDialog({
    super.key,
    this.existingModel,
    required this.settings,
  });

  @override
  ConsumerState<ModelEditDialog> createState() => _ModelEditDialogState();
}

class _ModelEditDialogState extends ConsumerState<ModelEditDialog> {
  late TextEditingController _nameController;
  late TextEditingController _modelIdController;
  late TextEditingController _apiKeyController;
  late TextEditingController _endpointController;
  late TextEditingController _systemInstructionController;
  late AIProvider _selectedProvider;
  late double _temperature;
  late double _topP;
  late int _topK;

  @override
  void initState() {
    super.initState();
    
    final model = widget.existingModel;
    _nameController = TextEditingController(text: model?.name ?? '');
    _modelIdController = TextEditingController(text: model?.modelId ?? '');
    _apiKeyController = TextEditingController(text: model?.apiKey ?? '');
    _endpointController = TextEditingController(text: model?.endpoint ?? 'http://localhost:1234/v1');
    _systemInstructionController = TextEditingController(text: model?.systemInstruction ?? '');
    _selectedProvider = model?.provider ?? AIProvider.openaiCompatible;
    _temperature = model?.temperature ?? 0.7;
    _topP = model?.topP ?? 0.9;
    _topK = model?.topK ?? 40;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _modelIdController.dispose();
    _apiKeyController.dispose();
    _endpointController.dispose();
    _systemInstructionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          children: [
            // ヘッダー
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  Text(
                    widget.existingModel == null ? 'モデルを追加' : 'モデルを編集',
                    style: const TextStyle(
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

            // フォーム
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 名前
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'モデル名',
                        hintText: 'Gemma 3n-e4b (LMStudio)',
                      ),
                    ),

                    const SizedBox(height: 16),

                    // プロバイダー
                    DropdownButtonFormField<AIProvider>(
                      value: _selectedProvider,
                      decoration: const InputDecoration(
                        labelText: 'プロバイダー',
                      ),
                      items: AIProvider.values.map((provider) {
                        return DropdownMenuItem(
                          value: provider,
                          child: Text(provider.value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedProvider = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    // モデルID
                    TextField(
                      controller: _modelIdController,
                      decoration: const InputDecoration(
                        labelText: 'モデルID',
                        hintText: 'gemma-2-27b-it',
                      ),
                    ),

                    const SizedBox(height: 16),

                    // エンドポイント（OpenAI互換/Azure用）
                    if (_selectedProvider != AIProvider.gemini)
                      TextField(
                        controller: _endpointController,
                        decoration: const InputDecoration(
                          labelText: 'エンドポイント',
                          hintText: 'http://localhost:1234/v1',
                        ),
                      ),

                    const SizedBox(height: 16),

                    // APIキー
                    TextField(
                      controller: _apiKeyController,
                      decoration: InputDecoration(
                        labelText: 'APIキー',
                        hintText: _selectedProvider == AIProvider.gemini
                            ? '必須'
                            : 'オプション（LMStudioは不要）',
                      ),
                      obscureText: true,
                    ),

                    const SizedBox(height: 24),

                    // 詳細設定
                    const Text(
                      '詳細設定',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Temperature
                    Text('Temperature: ${_temperature.toStringAsFixed(2)}'),
                    Slider(
                      value: _temperature,
                      min: 0.0,
                      max: 2.0,
                      divisions: 20,
                      onChanged: (value) {
                        setState(() {
                          _temperature = value;
                        });
                      },
                    ),

                    // Top P
                    Text('Top P: ${_topP.toStringAsFixed(2)}'),
                    Slider(
                      value: _topP,
                      min: 0.0,
                      max: 1.0,
                      divisions: 10,
                      onChanged: (value) {
                        setState(() {
                          _topP = value;
                        });
                      },
                    ),

                    // Top K
                    Text('Top K: $_topK'),
                    Slider(
                      value: _topK.toDouble(),
                      min: 1,
                      max: 100,
                      divisions: 99,
                      onChanged: (value) {
                        setState(() {
                          _topK = value.toInt();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            // フッター
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('キャンセル'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _saveModel,
                    child: const Text('保存'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveModel() {
    if (_nameController.text.trim().isEmpty ||
        _modelIdController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('名前とモデルIDは必須です')),
      );
      return;
    }

    final newModel = ModelConfig(
      id: widget.existingModel?.id ?? IdGenerator.generate(),
      name: _nameController.text.trim(),
      provider: _selectedProvider,
      modelId: _modelIdController.text.trim(),
      apiKey: _apiKeyController.text.trim().isEmpty
          ? null
          : _apiKeyController.text.trim(),
      endpoint: _endpointController.text.trim().isEmpty
          ? null
          : _endpointController.text.trim(),
      systemInstruction: _systemInstructionController.text.trim().isEmpty
          ? 'あなたは親切で役立つAIアシスタントです。'
          : _systemInstructionController.text.trim(),
      temperature: _temperature,
      topP: _topP,
      topK: _topK,
    );

    // 設定を更新
    List<ModelConfig> newModels;
    if (widget.existingModel == null) {
      newModels = List<ModelConfig>.from(widget.settings.models)..add(newModel);
    } else {
      newModels = widget.settings.models.map((m) {
        return m.id == newModel.id ? newModel : m;
      }).toList();
    }

    final newSettings = widget.settings.copyWith(
      models: newModels,
      activeModelId: widget.existingModel == null
          ? newModel.id
          : widget.settings.activeModelId,
    );

    ref.read(settingsProvider.notifier).updateSettings(newSettings);

    Navigator.of(context).pop();
  }
}
