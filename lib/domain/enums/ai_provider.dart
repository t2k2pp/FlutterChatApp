/// AIプロバイダーの種類を表すEnum
enum AIProvider {
  gemini('gemini'),
  openaiCompatible('openai_compatible'), // Ollama, LMStudio, LocalAI等
  azureOpenAI('azure_openai');

  const AIProvider(this.value);
  final String value;

  static AIProvider fromString(String value) {
    return AIProvider.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AIProvider.gemini,
    );
  }
}
