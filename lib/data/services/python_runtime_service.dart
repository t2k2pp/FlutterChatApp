import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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
/// WebViewを使ってブラウザ内でPythonコードを実行
class PythonRuntimeService {
  HeadlessInAppWebView? _webView;
  bool _isReady = false;
  bool _isLoading = false;
  Completer<void>? _initCompleter;
  Completer<PythonOutput>? _runCompleter;

  /// 初期化
  Future<void> initialize() async {
    if (_isReady) return;
    if (_isLoading) {
      await _initCompleter?.future;
      return;
    }

    _isLoading = true;
    _initCompleter = Completer<void>();

    try {
      _webView = HeadlessInAppWebView(
        initialData: InAppWebViewInitialData(
          data: _getPyodideHtml(),
          mimeType: 'text/html',
          encoding: 'utf-8',
        ),
        onWebViewCreated: (controller) {
          controller.addJavaScriptHandler(
            handlerName: 'pyodideReady',
            callback: (args) {
              _isReady = true;
              _isLoading = false;
              _initCompleter?.complete();
              print('Python環境準備完了');
            },
          );

          controller.addJavaScriptHandler(
            handlerName: 'pythonResult',
            callback: (args) {
              if (args.isNotEmpty) {
                final result = args[0] as Map<String, dynamic>;
                _runCompleter?.complete(PythonOutput(
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
                ));
              }
            },
          );

          controller.addJavaScriptHandler(
            handlerName: 'pyodideError',
            callback: (args) {
              final error = args.isNotEmpty ? args[0].toString() : 'Unknown error';
              _isLoading = false;
              _initCompleter?.completeError(Exception(error));
            },
          );
        },
        onLoadStop: (controller, url) async {
          // ページ読み込み完了後にPyodide初期化
          await controller.evaluateJavascript(source: 'initPyodide()');
        },
      );

      await _webView?.run();
      await _initCompleter?.future;
    } catch (e) {
      _isLoading = false;
      print('Python初期化エラー: $e');
      rethrow;
    }
  }

  /// Pythonコードを実行
  Future<PythonOutput> runCode(String code) async {
    if (!_isReady) {
      await initialize();
    }

    _runCompleter = Completer<PythonOutput>();

    try {
      final escapedCode = jsonEncode(code);
      await _webView?.webViewController?.evaluateJavascript(
        source: 'runPythonCode($escapedCode)',
      );

      return await _runCompleter!.future.timeout(
        const Duration(seconds: 60),
        onTimeout: () => PythonOutput(error: 'タイムアウト: 60秒を超えました'),
      );
    } catch (e) {
      return PythonOutput(error: e.toString());
    }
  }

  /// リセット
  void reset() {
    _webView?.webViewController?.evaluateJavascript(
      source: 'resetPython()',
    );
  }

  /// 破棄
  void dispose() {
    _webView?.dispose();
    _webView = null;
    _isReady = false;
  }

  /// Pyodide実行用HTML
  String _getPyodideHtml() {
    return '''
<!DOCTYPE html>
<html>
<head>
  <script src="https://cdn.jsdelivr.net/pyodide/v0.24.1/full/pyodide.js"></script>
</head>
<body>
<script>
let pyodide = null;

async function initPyodide() {
  try {
    pyodide = await loadPyodide();
    await pyodide.loadPackage(['micropip']);
    const micropip = pyodide.pyimport('micropip');
    await micropip.install(['pandas', 'numpy', 'matplotlib']);
    
    window.flutter_inappwebview.callHandler('pyodideReady', true);
  } catch (e) {
    window.flutter_inappwebview.callHandler('pyodideError', e.toString());
  }
}

async function runPythonCode(code) {
  const output = { stdout: '', stderr: '', images: [], files: [], error: null };
  
  pyodide.setStdout({ batched: (msg) => output.stdout += msg + '\\n' });
  pyodide.setStderr({ batched: (msg) => output.stderr += msg + '\\n' });
  
  // Matplotlib patch
  const patchCode = \`
import matplotlib.pyplot as plt
import io
import base64

def _show_patch():
    buf = io.BytesIO()
    plt.savefig(buf, format='png')
    buf.seek(0)
    img_str = base64.b64encode(buf.read()).decode('utf-8')
    print(f"__IMAGE_START__{img_str}__IMAGE_END__")
    plt.clf()

plt.show = _show_patch
\`;

  try {
    await pyodide.runPythonAsync(patchCode);
    await pyodide.runPythonAsync(code);
    
    // Check for generated files
    const fs = pyodide.FS;
    const allFiles = fs.readdir('.');
    const fileExts = ['.xlsx', '.csv', '.txt', '.json', '.png'];
    
    for (const file of allFiles) {
      if (fileExts.some(ext => file.endsWith(ext))) {
        const content = fs.readFile(file);
        const base64 = btoa(String.fromCharCode.apply(null, content));
        output.files.push({ name: file, data: base64 });
        fs.unlink(file);
      }
    }
  } catch (e) {
    output.error = e.toString();
  }
  
  // Extract images from stdout
  const imageRegex = /__IMAGE_START__(.*?)__IMAGE_END__/g;
  let match;
  while ((match = imageRegex.exec(output.stdout)) !== null) {
    output.images.push(match[1]);
  }
  output.stdout = output.stdout.replace(imageRegex, '');
  
  window.flutter_inappwebview.callHandler('pythonResult', output);
}

function resetPython() {
  if (pyodide) {
    pyodide.runPython("globals().clear()");
  }
}
</script>
</body>
</html>
''';
  }
}

/// シングルトンインスタンス
final pythonRuntime = PythonRuntimeService();
