import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_chat_app/domain/enums/thinking_level.dart';
import 'package:flutter_chat_app/domain/models/message_image.dart';
import 'package:flutter_chat_app/core/theme/app_colors.dart';
import 'dart:convert';
import 'dart:typed_data';

/// チャット入力ウィジェット
class ChatInput extends StatefulWidget {
  final Function({
    required String text,
    List<MessageImage>? images,
    bool webSearch,
    bool deepResearch,
    ThinkingLevel thinkingLevel,
    bool watsonEnabled,
  }) onSend;
  final bool isLoading;
  final bool searchEnabled;

  const ChatInput({
    super.key,
    required this.onSend,
    this.isLoading = false,
    this.searchEnabled = false,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  final List<_Attachment> _attachments = [];

  bool _webSearch = false;
  bool _deepResearch = false;
  ThinkingLevel _thinkingLevel = ThinkingLevel.off;
  bool _watsonEnabled = false;
  bool _showOptions = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'txt', 'md'],
      );

      if (result != null) {
        for (final file in result.files) {
          if (file.bytes != null) {
            final isImage = ['jpg', 'jpeg', 'png']
                .contains(file.extension?.toLowerCase());

            _attachments.add(_Attachment(
              name: file.name,
              bytes: file.bytes!,
              isImage: isImage,
            ));
          }
        }
        setState(() {});
      }
    } catch (e) {
      // エラー処理
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachments.removeAt(index);
    });
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty && _attachments.isEmpty) return;

    final images = _attachments
        .where((a) => a.isImage)
        .map((a) => MessageImage(
              base64: base64Encode(a.bytes),
              mimeType: 'image/${a.name.split('.').last}',
            ))
        .toList();

    widget.onSend(
      text: text,
      images: images.isNotEmpty ? images : null,
      webSearch: _webSearch,
      deepResearch: _deepResearch,
      thinkingLevel: _thinkingLevel,
      watsonEnabled: _watsonEnabled,
    );

    _controller.clear();
    _attachments.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // オプションボタン群
            if (_showOptions)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Web検索
                    if (widget.searchEnabled)
                      CheckboxListTile(
                        title: const Text('Web検索'),
                        subtitle: const Text('SearXNGで検索'),
                        value: _webSearch,
                        onChanged: (value) {
                          setState(() {
                            _webSearch = value ?? false;
                            if (!_webSearch) _deepResearch = false;
                          });
                        },
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),

                    // Deep Research
                    if (widget.searchEnabled && _webSearch)
                      CheckboxListTile(
                        title: const Text('Deep Research'),
                        subtitle: const Text('反復的な深い調査'),
                        value: _deepResearch,
                        onChanged: (value) {
                          setState(() {
                            _deepResearch = value ?? false;
                          });
                        },
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),

                    const Divider(),

                    // Thinking Level
                    ListTile(
                      title: const Text('思考レベル'),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    Wrap(
                      spacing: 8,
                      children: ThinkingLevel.values.map((level) {
                        return ChoiceChip(
                          label: Text(level.label),
                          selected: _thinkingLevel == level,
                          onSelected: (selected) {
                            setState(() {
                              _thinkingLevel = level;
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const Divider(),

                    // Watson
                    CheckboxListTile(
                      title: const Text('Watson Observer'),
                      subtitle: const Text('AIアドバイザーを有効化'),
                      value: _watsonEnabled,
                      onChanged: (value) {
                        setState(() {
                          _watsonEnabled = value ?? false;
                        });
                      },
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),

            // 添付ファイル表示
            if (_attachments.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _attachments.asMap().entries.map((entry) {
                    final index = entry.key;
                    final attachment = entry.value;
                    return Chip(
                      label: Text(
                        attachment.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () => _removeAttachment(index),
                    );
                  }).toList(),
                ),
              ),

            // 入力エリア
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // オプションボタン
                IconButton(
                  icon: Icon(
                    _showOptions ? Icons.tune : Icons.tune_outlined,
                    color: _showOptions ? AppColors.primary : null,
                  ),
                  onPressed: () {
                    setState(() {
                      _showOptions = !_showOptions;
                    });
                  },
                  tooltip: 'オプション',
                ),

                // 添付ファイルボタン
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: widget.isLoading ? null : _pickFile,
                  tooltip: 'ファイルを添付',
                ),

                // テキスト入力
                Expanded(
                  child: TextField(
                    controller: _controller,
                    maxLines: null,
                    enabled: !widget.isLoading,
                    decoration: InputDecoration(
                      hintText: 'メッセージを入力...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),

                const SizedBox(width: 8),

                // 送信ボタン
                IconButton.filled(
                  icon: widget.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.send),
                  onPressed: widget.isLoading ? null : _send,
                  tooltip: '送信',
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Attachment {
  final String name;
  final Uint8List bytes;
  final bool isImage;

  _Attachment({
    required this.name,
    required this.bytes,
    required this.isImage,
  });
}
