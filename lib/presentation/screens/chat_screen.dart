import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/theme/app_colors.dart';

/// チャット画面（メインスクリーン）
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isSidebarOpen = false;

  @override
  void initState() {
    super.initState();
    // デスクトップの場合はサイドバーを開いた状態で開始
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final width = MediaQuery.of(context).size.width;
      if (width >= 1024) {
        setState(() {
          _isSidebarOpen = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // サイドバー（実装予定）
          if (_isSidebarOpen)
            Container(
              width: 280,
              color: const Color(0xFFF0EFEA),
              child: const Center(
                child: Text('Sidebar (実装予定)'),
              ),
            ),

          // メインコンテンツ
          Expanded(
            child: Column(
              children: [
                // ヘッダー
                _buildHeader(),

                // チャットエリア
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: const Center(
                      child: Text('Chat Area (実装予定)'),
                    ),
                  ),
                ),

                // 入力エリア
                _buildInputArea(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 56,
      decoration: const BoxDecoration(
        color: AppColors.surfaceAlt,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // サイドバートグルボタン
            if (!_isSidebarOpen)
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  setState(() {
                    _isSidebarOpen = true;
                  });
                },
                tooltip: 'サイドバーを開く',
              ),

            // タイトル
            const Text(
              'Multi GenAI Chat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),

            const Spacer(),

            // モデルセレクター（実装予定）
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.model_training, size: 16),
              label: const Text('Gemini 2.0 Flash'),
            ),

            // ダウンロードボタン
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () {},
              tooltip: 'チャットをダウンロード',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // 添付ファイルボタン
            IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: () {},
              tooltip: 'ファイルを添付',
            ),

            // テキスト入力
            Expanded(
              child: TextField(
                maxLines: null,
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
              ),
            ),

            const SizedBox(width: 8),

            // 送信ボタン
            IconButton.filled(
              icon: const Icon(Icons.send),
              onPressed: () {},
              tooltip: '送信',
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
