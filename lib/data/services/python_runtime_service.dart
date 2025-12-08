import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;

// プラットフォーム固有の実装
import 'python_runtime_stub.dart'
    if (dart.library.io) 'python_runtime_native.dart'
    if (dart.library.html) 'python_runtime_web.dart' as platform;

/// Python実行結果
class PythonOutput {
  final String stdout;
  final String stderr;
  final List<String> images; // Base64文字列
  final List<PythonFile> files;
  final String? error;

  PythonOutput({
    this.stdout = '',
    this.stderr = '',
    this.images = const [],
    this.files = const [],
    this.error,
  });
}

/// 生成されたファイル
class PythonFile {
  final String name;
  final String base64Data;

  PythonFile({required this.name, required this.base64Data});
}

/// Python実行サービス (Pyodide使用)
class PythonRuntimeService {
  bool _isReady = false;
  bool _isLoading = false;

  /// 初期化
  Future<void> initialize() async {
    if (_isReady) return;
    if (_isLoading) return;

    _isLoading = true;
    try {
      await platform.initializePyodide();
      _isReady = true;
    } finally {
      _isLoading = false;
    }
  }

  /// Pythonコードを実行
  Future<PythonOutput> runCode(String code) async {
    if (!_isReady) {
      await initialize();
    }

    try {
      final result = await platform.runPythonCode(code);
      return PythonOutput(
        stdout: result['stdout'] ?? '',
        stderr: result['stderr'] ?? '',
        images: List<String>.from(result['images'] ?? []),
        files: (result['files'] as List?)
                ?.map((f) => PythonFile(
                      name: f['name'],
                      base64Data: f['data'],
                    ))
                .toList() ??
            [],
        error: result['error'],
      );
    } catch (e) {
      return PythonOutput(error: e.toString());
    }
  }

  /// リセット
  void reset() {
    platform.resetPython();
  }

  /// 利用可能かどうか
  bool get isAvailable => kIsWeb; // 現在はWebのみ対応

  /// 破棄
  void dispose() {
    // プラットフォーム固有のクリーンアップ
  }
}

/// シングルトンインスタンス
final pythonRuntime = PythonRuntimeService();
