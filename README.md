# Multi GenAI Chat - Flutter App

ReactベースのClaude-style-gemini-chatをFlutterに完全移植したアプリケーション。

## 特徴

### 🤖 マルチプロバイダーAIサポート
- **Gemini API** - Google Generative AI（ストリーミング対応）
- **OpenAI互換** - Ollama、LMStudio、LocalAI等
- **Azure OpenAI** - エンタープライズ対応

### 🧠 高度なAI機能
- **Watson Observer** - セカンダリAIがメインAIの応答を監視し、必要に応じて介入
  - 3段階の介入レベル（Minimal、Balanced、Proactive）
- **Thinking Agent** - 多段階推論システム
  - Quick: Plan → Answer
  - Balanced: Plan → Draft → Critique → Refine
  - Deep: Plan → Draft → Critique → Refine → Critique → Final Polish
- **Deep Research** - 反復的なWeb検索と統合
  - SearXNGベース
  - 最大3イテレーション

### 📝 豊富な入出力機能
- **ファイル添付** - PDF、DOCX、TXT、JSON、画像
- **Markdown表示** - コードハイライト、テーブル、リスト
- **アーティファクトパネル** - HTML/SVGプレビュー、コード表示
- **エクスポート** - ZIP（Markdown）、PDF

### 🎤 音声機能
- **Text-to-Speech** - メッセージ読み上げ
- **Speech-to-Text** - 音声入力（予定）

### 💾 データ管理
- **Hive** - ローカルストレージ
- **セッション管理** - チャット履歴の保存・復元
- **プロジェクト/Gems** - カスタムインストラクションと知識ベース

## インストール

### 前提条件
- Flutter SDK 3.8.1+
- Dart 3.0+

### セットアップ

1. リポジトリをクローン:
```bash
git clone https://github.com/t2k2pp/FlutterChatApp.git
cd FlutterChatApp
```

2. 依存関係をインストール:
```bash
flutter pub get
```

3. コード生成:
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. 環境変数を設定（オプション）:
```bash
# .env ファイルを作成
GEMINI_API_KEY=your_gemini_api_key_here
```

5. アプリを実行:
```bash
# デスクトップ
flutter run -d windows  # または macos/linux

# モバイル
flutter run -d android  # または ios
```

## 設定

### AIモデルの追加

1. アプリを起動して設定画面を開く
2. 「モデル」タブを選択
3. 「モデルを追加」をクリック
4. 必要な情報を入力:
   - 名前
   - プロバイダー（Gemini / OpenAI互換 / Azure OpenAI）
   - モデルID
   - APIキー（オプション）
   - エンドポイント（OpenAI互換/Azure用）

### Web検索の設定

1. SearXNGインスタンスをセットアップ:
```bash
docker run -d -p 8080:8080 searxng/searxng
```

2. 設定画面で:
   - 「検索」タブを選択
   - 「Web検索を有効化」をON
   - Base URL を設定（例: `http://localhost:8080`）

## アーキテクチャ

```
lib/
├── core/
│   ├── constants/      # アプリ定数
│   ├── theme/         # テーマとカラー
│   └── utils/         # ユーティリティ
├── data/
│   ├── datasources/   # データソース（ローカル/リモート）
│   ├── repositories/  # リポジトリ実装
│   └── services/      # ビジネスロジック
├── domain/
│   ├── models/        # ドメインモデル（Freezed）
│   ├── repositories/  # リポジトリインターフェース
│   └── enums/         # 列挙型
└── presentation/
    ├── providers/     # Riverpod状態管理
    ├── screens/       # 画面
    ├── widgets/       # UIコンポーネント
    └── dialogs/       # ダイアログ
```

### 使用技術

- **状態管理**: Riverpod 2.5+
- **シリアライゼーション**: Freezed + json_annotation
- **ローカルDB**: Hive
- **AI SDK**: google_generative_ai, HTTP（OpenAI互換）
- **UI**: flutter_markdown, flutter_highlight
- **ファイル処理**: syncfusion_flutter_pdf, archive
- **WebView**: flutter_inappwebview

## 使い方

### 基本的なチャット
1. 入力欄にメッセージを入力
2. 送信ボタンをクリックまたはEnterキー
3. AIの応答を待つ

### オプション機能の利用
1. 入力欄の左側にある「オプション」ボタンをクリック
2. 必要な機能を有効化:
   - **Web検索** - インターネットから情報を取得
   - **Deep Research** - 複数回の検索で深く調査
   - **思考レベル** - AIの推論深度を調整
   - **Watson Observer** - セカンダリAIによる監視

### ファイル添付
1. 入力欄の「📎」ボタンをクリック
2. サポートされているファイルを選択
3. メッセージと一緒に送信

## 開発状況

### ✅ 完了（約85%）
- ドメイン層（100%）
- データ層（95%）
- プレゼンテーション層（70%）
  - 主要UIコンポーネント
  - Riverpod統合
  - 設定画面
  - サイドバー

### ⏳ 進行中（約15%）
- Python実行環境（WebView + Pyodide）
- プロジェクトマネージャーUI
- 細かなバグ修正
- パフォーマンス最適化

## ライセンス

MIT License

## 貢献

プルリクエストを歓迎します！

## 問題報告

バグや機能リクエストは [Issues](https://github.com/t2k2pp/FlutterChatApp/issues) で報告してください。

## 謝辞

元のReactアプリケーション [claude-style-gemini-chat](https://github.com/example/claude-style-gemini-chat) にインスパイアされました。
