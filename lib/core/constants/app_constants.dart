import 'package:flutter_chat_app/domain/models/model_config.dart';
import 'package:flutter_chat_app/domain/models/search_config.dart';
import 'package:flutter_chat_app/domain/models/tts_config.dart';
import 'package:flutter_chat_app/domain/models/user_settings.dart';
import 'package:flutter_chat_app/domain/enums/ai_provider.dart';
import 'package:flutter_chat_app/domain/enums/watson_intervention_level.dart';

/// デフォルトのシステム指示
const defaultSystemInstruction = '''
あなたは親切で知的なAIアシスタントです。
あなたの応答は、Markdownを使用して明確、簡潔、かつ適切に構造化されている必要があります。

重要:
1. **HTML/JSアプリ**: Webアプリ、ゲーム、またはインタラクティブな可視化の作成を求められた場合、単一の自己完結型HTMLファイル（CSS/JSを埋め込み）を提供してください。
2. **Python分析**: WebAssembly経由でPython環境にアクセスできます。
   - ユーザーがデータ分析、数学、チャート、またはファイル生成（Excel/CSV等）を求める場合、Pythonコードを記述してください。
   - 'pandas'、'numpy'、'openpyxl'（Excel用）、および'matplotlib'を使用します。
   - Pythonでプロットを表示するには、figureを作成するだけです。環境が自動的にキャプチャします。
   - ファイルを生成するには、現在のディレクトリに保存します（例：'output.xlsx'）。
3. **マルチモーダル**: ユーザーが画像を提供した場合、詳細に分析します。
4. **一般的なコード**: 適切な構文ハイライトを使用します。
5. **アドバイザー入力**: 時々、"[Advisor Watson]"という接頭辞付きのメッセージが表示されることがあります。
   - これらは会話を観察しているセカンダリAIからの入力です。
   - これらを**提案**または**修正**として扱います。
   - **盲目的に従わないでください。**自分で妥当性を確認してください。
   - アドバイザーが間違いを指摘した場合、それを認めて修正してください。
   - アドバイザーが簡略化を提案した場合、それがユーザーに役立つか検討してください。

専門的でありながら会話的なトーンを採用し、知識豊富な同僚のようにふるまってください。
''';

/// モデルタイプの列挙
class ModelType {
  static const flash = 'gemini-2.0-flash-exp';
  static const pro = 'gemini-2.0-flash-thinking-exp-01-21';
}

/// デフォルトのモデル設定
final List<ModelConfig> defaultModels = [
  // LMStudio (ローカルLLM) - 開発時のデフォルト
  ModelConfig(
    id: 'lmstudio-local',
    name: 'LMStudio (Local)',
    provider: AIProvider.openaiCompatible,
    modelId: 'local-model',
    endpoint: 'http://localhost:1234/v1',
    systemInstruction: defaultSystemInstruction,
    temperature: 0.7,
    topP: 0.95,
    topK: 64,
    capabilities: const [],
  ),
  ModelConfig(
    id: 'default-gemini-flash',
    name: 'Gemini 2.0 Flash',
    provider: AIProvider.gemini,
    modelId: ModelType.flash,
    systemInstruction: defaultSystemInstruction,
    temperature: 0.7,
    topP: 0.95,
    topK: 64,
    capabilities: const ['image'],
  ),
  ModelConfig(
    id: 'default-gemini-pro',
    name: 'Gemini 2.0 Flash Thinking',
    provider: AIProvider.gemini,
    modelId: ModelType.pro,
    systemInstruction: defaultSystemInstruction,
    temperature: 0.7,
    topP: 0.95,
    topK: 64,
    capabilities: const ['image'],
  ),
];

/// デフォルトの検索設定
const defaultSearchConfig = SearchConfig(
  enabled: false,
  provider: 'searxng',
  baseUrl: 'http://localhost:8080',
  deepResearchEnabled: false,
  maxIterations: 3,
);

/// デフォルトのTTS設定
const defaultTTSConfig = TTSConfig(
  voiceURI: null,
  speed: 1.0,
);

/// デフォルトのユーザー設定
final defaultSettings = UserSettings(
  models: defaultModels,
  activeModelId: 'lmstudio-local', // デフォルトでLMStudioを使用
  subModelId: 'default-gemini-flash', // デフォルトのWatsonモデル
  watsonInterventionLevel: WatsonInterventionLevel.medium,
  projects: const [],
  search: defaultSearchConfig,
  tts: defaultTTSConfig,
  timeAwareness: true,
);

