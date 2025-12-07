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
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // テキスト入力
                  TextField(
                    controller: _controller,
                    maxLines: null,
                    enabled: !widget.isLoading,
                    decoration: const InputDecoration(
                      hintText: 'How can I help you today?',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                  
                  // オプション行（コンパクト版）
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: AppColors.border)),
                    ),
                    child: Row(
                      children: [
                        // 添付ファイルボタン
                        _buildCompactButton(
                          icon: Icons.attach_file,
                          label: null,
                          isActive: false,
                          onTap: widget.isLoading ? null : _pickFile,
                        ),
                        
                        const SizedBox(width: 4),
                        
                        // Watson Observer トグル
                        _buildCompactButton(
                          icon: Icons.psychology_outlined,
                          label: 'Watson',
                          isActive: _watsonEnabled,
                          onTap: () {
                            setState(() {
                              _watsonEnabled = !_watsonEnabled;
                            });
                          },
                        ),
                        
                        const SizedBox(width: 4),
                        
                        // Thinking Level
                        Builder(
                          builder: (context) => _buildCompactButton(
                            icon: Icons.bolt,
                            label: 'Thinking ${_thinkingLevel.label}',
                            isActive: _thinkingLevel != ThinkingLevel.off,
                            onTap: () => _showThinkingPopup(context),
                          ),
                        ),
                        
                        // Web検索
                        if (widget.searchEnabled) ...[
                          const SizedBox(width: 4),
                          _buildCompactButton(
                            icon: Icons.language,
                            label: 'Search',
                            isActive: _webSearch,
                            onTap: () {
                              setState(() {
                                _webSearch = !_webSearch;
                                if (!_webSearch) _deepResearch = false;
                              });
                            },
                          ),
                        ],
                        
                        // Deep Research
                        if (widget.searchEnabled && _webSearch) ...[
                          const SizedBox(width: 4),
                          _buildCompactButton(
                            icon: Icons.science_outlined,
                            label: 'Deep Research',
                            isActive: _deepResearch,
                            onTap: () {
                              setState(() {
                                _deepResearch = !_deepResearch;
                              });
                            },
                          ),
                        ],
                        
                        const Spacer(),
                        
                        // 送信ボタン
                        IconButton(
                          icon: widget.isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.send),
                          onPressed: widget.isLoading ? null : _send,
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
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
  
  Widget _buildCompactButton({
    required IconData icon,
    String? label,
    required bool isActive,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            ),
            if (label != null) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  void _showThinkingPopup(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final Offset buttonPosition = button.localToGlobal(Offset.zero, ancestor: overlay);
    
    // ボタンの上にポップアップを表示
    final RelativeRect position = RelativeRect.fromLTRB(
      buttonPosition.dx,
      buttonPosition.dy - 150, // ボタンの上に表示
      overlay.size.width - buttonPosition.dx - button.size.width,
      overlay.size.height - buttonPosition.dy,
    );
    
    showMenu<ThinkingLevel>(
      context: context,
      position: position,
      items: ThinkingLevel.values.map((level) {
        return PopupMenuItem<ThinkingLevel>(
          value: level,
          child: Row(
            children: [
              if (_thinkingLevel == level)
                const Icon(Icons.check, size: 16, color: AppColors.primary)
              else
                const SizedBox(width: 16),
              const SizedBox(width: 8),
              Text(level.label),
            ],
          ),
        );
      }).toList(),
    ).then((value) {
      if (value != null) {
        setState(() {
          _thinkingLevel = value;
        });
      }
    });
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
