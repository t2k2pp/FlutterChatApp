// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'dart:async';

bool _isInitialized = false;
Completer<void>? _initCompleter;

/// Web用Python実装（Pyodide使用）
Future<void> initializePyodide() async {
  if (_isInitialized) return;
  
  if (_initCompleter != null) {
    await _initCompleter!.future;
    return;
  }
  
  _initCompleter = Completer<void>();
  
  try {
    // Pyodideが読み込まれているか確認
    if (js.context['loadPyodide'] == null) {
      throw Exception('Pyodide script not loaded. Add to index.html');
    }
    
    // Pyodideを初期化
    final pyodide = await js.context.callMethod('loadPyodide');
    js.context['pyodide'] = pyodide;
    
    // micropipをロード
    await _callAsync(pyodide, 'loadPackage', ['micropip']);
    
    // 必要なパッケージをインストール
    final micropip = pyodide.callMethod('pyimport', ['micropip']);
    await _callAsync(micropip, 'install', [js.JsArray.from(['pandas', 'numpy', 'matplotlib'])]);
    
    _isInitialized = true;
    _initCompleter!.complete();
    print('Python環境準備完了');
  } catch (e) {
    _initCompleter!.completeError(e);
    rethrow;
  }
}

Future<Map<String, dynamic>> runPythonCode(String code) async {
  final output = <String, dynamic>{
    'stdout': '',
    'stderr': '',
    'images': <String>[],
    'files': <Map<String, dynamic>>[],
    'error': null,
  };
  
  try {
    final pyodide = js.context['pyodide'];
    if (pyodide == null) {
      throw Exception('Pyodide not initialized');
    }
    
    // Matplotlib patch
    const patchCode = '''
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
''';
    
    await _callAsync(pyodide, 'runPythonAsync', [patchCode]);
    
    // ユーザーコードを実行
    await _callAsync(pyodide, 'runPythonAsync', [code]);
    
    // 標準出力を取得
    // Note: 実際の実装ではstdoutの取得方法を調整する必要がある
    
  } catch (e) {
    output['error'] = e.toString();
  }
  
  return output;
}

void resetPython() {
  final pyodide = js.context['pyodide'];
  if (pyodide != null) {
    pyodide.callMethod('runPython', ['globals().clear()']);
  }
}

/// 非同期JavaScriptメソッドを呼び出す
Future<dynamic> _callAsync(dynamic obj, String method, List<dynamic> args) {
  final completer = Completer<dynamic>();
  final promise = obj.callMethod(method, args);
  
  js.context['Promise'].callMethod('resolve', [promise]).callMethod('then', [
    js.allowInterop((result) => completer.complete(result)),
    js.allowInterop((error) => completer.completeError(error.toString())),
  ]);
  
  return completer.future;
}
