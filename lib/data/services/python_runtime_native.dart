/// ネイティブ（Android/iOS）用Python実装
/// 現在はAndroidでPyodideを直接実行することは困難なため、
/// 将来的にはWebViewを使った実装を検討
Future<void> initializePyodide() async {
  // Android版では現在未対応
  print('Python実行はAndroidでは現在未対応です');
}

Future<Map<String, dynamic>> runPythonCode(String code) async {
  return {
    'stdout': '',
    'stderr': '',
    'images': <String>[],
    'files': <Map<String, dynamic>>[],
    'error': 'Python実行はAndroidでは現在未対応です。Web版をご利用ください。',
  };
}

void resetPython() {
  // No-op
}
