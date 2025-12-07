import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_chat_app/domain/models/message.dart';
import 'package:flutter_chat_app/domain/enums/role.dart';
import 'package:flutter_chat_app/core/theme/app_colors.dart';

/// チャットメッセージウィジェット
class ChatMessage extends StatefulWidget {
  final Message message;
  final VoidCallback? onToggleContext;

  const ChatMessage({
    super.key,
    required this.message,
    this.onToggleContext,
  });

  @override
  State<ChatMessage> createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  bool _copied = false;
  bool _showReasoning = false;

  @override
  Widget build(BuildContext context) {
    final isUser = widget.message.role == Role.user;
    final isWatson = widget.message.role == Role.watson;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isUser
            ? Colors.transparent
            : (isWatson ? const Color(0xFFF0F4FF) : const Color(0xFFFAFAFA)),
        border: Border(
          bottom: BorderSide(
            color: AppColors.border.withOpacity(0.3),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // アイコン
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isUser
                  ? AppColors.primary
                  : (isWatson ? AppColors.watson : Colors.grey[300]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isUser
                  ? Icons.person
                  : (isWatson ? Icons.psychology : Icons.smart_toy),
              color: Colors.white,
              size: 18,
            ),
          ),

          const SizedBox(width: 12),

          // メッセージコンテンツ
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ロール名
                Row(
                  children: [
                    Text(
                      isUser ? 'You' : (isWatson ? 'Watson' : 'AI'),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    // Watson承認チェックマーク
                    if (widget.message.watsonChecked == true)
                      const Icon(
                        Icons.verified,
                        size: 16,
                        color: Colors.green,
                      ),
                  ],
                ),

                const SizedBox(height: 8),

                // メッセージテキスト
                MarkdownBody(
                  data: widget.message.text,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(fontSize: 14, height: 1.5),
                    code: TextStyle(
                      backgroundColor: Colors.grey[200],
                      fontFamily: 'monospace',
                    ),
                    codeblockDecoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                // 画像表示
                if (widget.message.images != null &&
                    widget.message.images!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.message.images!.map((img) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            const Base64Decoder().convert(img.base64),
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                // 推論ログ
                if (widget.message.reasoningLogs != null &&
                    widget.message.reasoningLogs!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              _showReasoning = !_showReasoning;
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                _showReasoning
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '推論ログ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (_showReasoning)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.message.reasoningLogs!.first.content,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                const SizedBox(height: 8),

                // アクションボタン
                Row(
                  children: [
                    // コピーボタン
                    IconButton(
                      icon: Icon(
                        _copied ? Icons.check : Icons.copy,
                        size: 16,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: widget.message.text),
                        );
                        setState(() {
                          _copied = true;
                        });
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) {
                            setState(() {
                              _copied = false;
                            });
                          }
                        });
                      },
                      tooltip: 'コピー',
                    ),

                    const SizedBox(width: 8),

                    // Watsonコンテキストトグル
                    if (widget.message.role == Role.watson &&
                        widget.onToggleContext != null)
                      IconButton(
                        icon: Icon(
                          widget.message.includedInContext
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 16,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: widget.onToggleContext,
                        tooltip: 'コンテキストに含める',
                      ),

                    const SizedBox(width: 8),

                    // タイムスタンプ
                    Text(
                      _formatTimestamp(widget.message.timestamp),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 1) {
      return 'たった今';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes}分前';
    } else if (diff.inDays < 1) {
      return '${diff.inHours}時間前';
    } else {
      return '${date.month}/${date.day} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    }
  }
}
