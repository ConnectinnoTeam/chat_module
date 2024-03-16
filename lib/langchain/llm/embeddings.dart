import 'package:chat_module/langchain/llm/llm.dart';
import 'package:langchain/langchain.dart';
import 'package:langchain_google/langchain_google.dart';
import 'package:langchain_mistralai/langchain_mistralai.dart';
import 'package:langchain_ollama/langchain_ollama.dart';
import 'package:langchain_openai/langchain_openai.dart';

enum LLMEnum {
  chatOpenAI,
  openAI,
  gemini,
  chatMistralAI,
  chatOllama;

  const LLMEnum();

  LLM llm({
    double? temperature,
    int? maxToken,
    String? baseURL,
    required String apiKey,
  }) {
    return switch (this) {
      LLMEnum.chatOpenAI => LLM(
          ChatOpenAI(
            apiKey: apiKey,
            defaultOptions: ChatOpenAIOptions(
              temperature: temperature,
              maxTokens: maxToken,
              model: "gpt-3.5-turbo",
            ),
          ),
          OpenAIEmbeddings(apiKey: apiKey),
        ),
      LLMEnum.openAI => LLM(
          OpenAI(
            apiKey: apiKey,
            defaultOptions: OpenAIOptions(
                temperature: temperature,
                maxTokens: maxToken,
                model: "gpt-3.5-turbo"),
          ),
          OpenAIEmbeddings(apiKey: apiKey),
        ),
      LLMEnum.gemini => LLM(
          ChatGoogleGenerativeAI(
            apiKey: apiKey,
            defaultOptions: ChatGoogleGenerativeAIOptions(
              temperature: temperature,
              maxOutputTokens: maxToken,
            ),
          ),
          FakeEmbeddings(),
        ),
      LLMEnum.chatMistralAI => LLM(
          ChatMistralAI(
            apiKey: apiKey,
            defaultOptions: ChatMistralAIOptions(
              temperature: temperature,
              maxTokens: maxToken,
            ),
          ),
          MistralAIEmbeddings(),
        ),
      LLMEnum.chatOllama => LLM(
          ChatOllama(
            baseUrl: baseURL!,
            defaultOptions: ChatOllamaOptions(temperature: temperature),
          ),
          OllamaEmbeddings(),
        ),
    };
  }
}
