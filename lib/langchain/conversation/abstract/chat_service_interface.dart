import 'package:chat_module/langchain/constants/chat_service_constants.dart';
import 'package:chat_module/langchain/llm/embeddings.dart';
import 'package:chat_module/langchain/llm/llm.dart';
import 'package:chat_module/langchain/response/output_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:langchain/langchain.dart';

abstract class ILangChainService {
  @protected
  final LLM llm;
  @protected
  late final RunnableSequence<Object, Map<String, String>> chain;

  @protected
  final BaseChatPromptTemplate selectedTemplate;

  @protected
  BaseChatMemory baseChatMemory;

  final String apiKey;

  BaseChatMemory get memory => baseChatMemory;

  ILangChainService({
    required this.apiKey,
    required LLMEnum llmEnum,
    required this.selectedTemplate,
    required int maxToken,
    required double temperature,
    required BaseChatMemory memory,
  })  : llm = llmEnum.llm(
          apiKey: apiKey,
          temperature: temperature,
          maxToken: maxToken,
        ),
        baseChatMemory = memory {
    final outputParser = CustomOutputParser();

    final memoryMap = Runnable.fromMap({
      LangchainServiceConst.defaultInputKey: Runnable.passthrough(),
      LangchainServiceConst.defaultMemoryKey: Runnable.fromFunction(
        (final _, final __) async {
          final m = await baseChatMemory.loadMemoryVariables();
          return m[LangchainServiceConst.defaultMemoryKey];
        },
      ),
    });

    chain = memoryMap.pipe(selectedTemplate).pipe(llm.model).pipe(outputParser);
  }

  Stream<Object> generateStreamResponse(String question);
  void generateListenStreamResponse(String question, void Function() onListen);
  Future<void> saveMemory(HumanChatMessage input, AIChatMessage output);
  void saveUserMessage(HumanChatMessage message);
  void saveAIMessage(AIChatMessage message);
  Future<List<ChatMessage>> getHistory();
  void clearMemory();
}
