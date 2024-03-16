import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:chat_module/langchain/constants/memory_sizes.dart';
import 'package:chat_module/langchain/conversation/concrete/chat_service.dart';
import 'package:chat_module/langchain/llm/embeddings.dart';
import 'package:chat_module/langchain/response/chat_finish_reasons.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:langchain/langchain.dart';

import 'test_initializer.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();

  final promptTemplate = ChatPromptTemplate.fromPromptMessages([
    SystemChatMessagePromptTemplate.fromTemplate(
      'You are a helpful chatbot',
    ),
    const MessagesPlaceholder(variableName: 'history'),
    HumanChatMessagePromptTemplate.fromTemplate('{input}'),
  ]);

  final chatService = LangChainChatService(
    delay: const Duration(milliseconds: 5),
    apiKey: 'YOUR_API_KEY',
    llmEnum: LLMEnum.chatOpenAI,
    selectedTemplate: promptTemplate,
    maxToken: 1500,
    temperature: 0.5,
    memory: ConversationBufferWindowMemory(
      returnMessages: true,
      k: MemorySizes.large,
    ),
  );

  test('Langchain hook test', () async {
    chatService.hook(
      hook: (text) => print(text),
      onDone: (reason) => {},
    );

    final reason = await chatService.sendMessage("YAŞAMIN ANLAMI NEDİR?");
    await Future.delayed(const Duration(seconds: 2));
    chatService.cancelStream();
    log("İLK STREAM BİTTİ");
    final reason2 = await chatService.sendMessage("İki kere iki kaç eder?");
    expect(reason2, ChatCompletionFinishReason.finished);

    await Future.delayed(const Duration(seconds: 100));
  });
}
