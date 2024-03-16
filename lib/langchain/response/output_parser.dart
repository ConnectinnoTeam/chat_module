import 'package:langchain/langchain.dart';

class CustomOutputParser extends BaseLLMOutputParser<AIChatMessage,
    BaseLangChainOptions, Map<String, String>> {
  @override
  Future<Map<String, String>> parseResult(
    final List<LanguageModelGeneration<AIChatMessage>> result,
  ) async {
    final generation = result.first;
    final text = generation.outputAsString;
    final finishReason = generation.generationInfo?['finish_reason'];
    return {
      'text': text,
      'finish_reason': finishReason.toString(),
    };
  }
}
