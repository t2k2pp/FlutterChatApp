import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_app/domain/models/artifact.dart';
import 'package:flutter_chat_app/domain/enums/artifact_type.dart';
import 'package:flutter_chat_app/core/theme/app_colors.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// Artifact表示パネル
class ArtifactPanel extends StatefulWidget {
  final Artifact artifact;
  final VoidCallback onClose;

  const ArtifactPanel({
    super.key,
    required this.artifact,
    required this.onClose,
  });

  @override
  State<ArtifactPanel> createState() => _ArtifactPanelState();
}

class _ArtifactPanelState extends State<ArtifactPanel> {
  bool _showPreview = true;
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: AppColors.border, width: 2),
        ),
      ),
      child: Column(
        children: [
          // ヘッダー
          _buildHeader(),

          // タブ
          _buildTabs(),

          // コンテンツ
          Expanded(
            child: _showPreview ? _buildPreview() : _buildCodeView(),
          ),

          // フッター（アクションボタン）
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.artifact.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.artifact.type.displayName,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: widget.onClose,
            tooltip: '閉じる',
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          _buildTab('プレビュー', _showPreview, () {
            setState(() => _showPreview = true);
          }),
          _buildTab('コード', !_showPreview, () {
            setState(() => _showPreview = false);
          }),
        ],
      ),
    );
  }

  Widget _buildTab(String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
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
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreview() {
    if (widget.artifact.type == ArtifactType.html || 
        widget.artifact.type == ArtifactType.svg) {
      return _buildWebViewPreview();
    } else {
      return _buildCodeView();
    }
  }

  Widget _buildWebViewPreview() {
    String htmlContent;
    
    if (widget.artifact.type == ArtifactType.svg) {
      htmlContent = '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
          body { margin: 0; padding: 20px; display: flex; justify-content: center; align-items: center; min-height: 100vh; }
        </style>
      </head>
      <body>
        ${widget.artifact.content}
      </body>
      </html>
      ''';
    } else {
      htmlContent = widget.artifact.content;
    }

    return InAppWebView(
      initialData: InAppWebViewInitialData(data: htmlContent),
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        useHybridComposition: true,
      ),
    );
  }

  Widget _buildCodeView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: HighlightView(
        widget.artifact.content,
        language: widget.artifact.language,
        theme: githubTheme,
        padding: const EdgeInsets.all(12),
        textStyle: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: Row(
        children: [
          // コピーボタン
          ElevatedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: widget.artifact.content));
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
            icon: Icon(_copied ? Icons.check : Icons.copy, size: 16),
            label: Text(_copied ? 'コピー済み' : 'コピー'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.textPrimary,
              elevation: 0,
              side: const BorderSide(color: AppColors.border),
            ),
          ),
          const Spacer(),
          // ダウンロードボタン
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // TODO: ダウンロード機能
            },
            tooltip: 'ダウンロード',
          ),
        ],
      ),
    );
  }
}
