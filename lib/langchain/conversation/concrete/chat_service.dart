import 'dart:async';

import 'package:async_queue/async_queue.dart';
import 'package:chat_module/langchain/constants/chat_service_constants.dart';
import 'package:chat_module/langchain/conversation/abstract/chat_service_interface.dart';
import 'package:chat_module/langchain/response/chat_completion_response.dart';
import 'package:chat_module/langchain/response/chat_finish_reasons.dart';
import 'package:chat_module/utility/extensions/string_extensions.dart';
import 'package:langchain/langchain.dart';

class LangChainChatService extends ILangChainService {
  LangChainChatService({
    required super.llmEnum,
    required super.selectedTemplate,
    required super.maxToken,
    required super.temperature,
    required super.memory,
    required super.apiKey,
    required this.delay,
  });

/*
{"text: "SOME_TEXT", "finish_reason" }
 */

  final Duration delay;

  late final void Function(String? text)? _hook;
  late final void Function(ChatCompletionFinishReason reason) _onDone;

  final _asyncQueue = AsyncQueue.autoStart();

  StreamSubscription<ChatCompletionResponse>? _streamSubscription;

  Future<ChatCompletionFinishReason> sendMessage(String message) {
    final completer = Completer<ChatCompletionFinishReason>();
    final stream = generateStreamResponse(message);
    _streamSubscription = stream.listen(
      (event) => _feedHook(event, completer),
      cancelOnError: true,
      onError: (e) {
        if (e is Map<String, dynamic>) {
          final response = ChatCompletionResponse.fromJson(e);
          _onDone(response.finishReason!);
          completer.complete(response.finishReason!);
        } else {
          completer.complete(ChatCompletionFinishReason.error);
        }
      },
    );
    return completer.future;
  }

  void cancelStream() {
    _asyncQueue.stop();
    _asyncQueue.clear();
    _streamSubscription?.cancel();
  }

  @override
  Stream<ChatCompletionResponse> generateStreamResponse(
      String question) async* {
    await for (var map
        in chain.stream({'input': question}).asBroadcastStream()) {
      yield ChatCompletionResponse.fromJson(map);
    }
  }

  void hook({
    required void Function(String? text) hook,
    required void Function(ChatCompletionFinishReason reason) onDone,
  }) {
    _hook = hook;
    _onDone = onDone;
  }

  void _feedHook(ChatCompletionResponse event,
      Completer<ChatCompletionFinishReason> completer) {
    _asyncQueue.addJob((_) async {
      final response = _feedHookDone(event, completer);
      final output = event.text;
      if (output == null || response) return;
      for (var ch in output.expanded()) {
        await Future.delayed(delay);
        _hook?.call(ch);
      }
    });
  }

  bool _feedHookDone(ChatCompletionResponse event,
      Completer<ChatCompletionFinishReason> completer) {
    if (event.finishReason != null &&
        event.finishReason != ChatCompletionFinishReason.nullResponse) {
      _onDone(event.finishReason!);
      completer.complete(event.finishReason!);
      return true;
    }
    return false;
  }

  @override
  void generateListenStreamResponse(
      String question, void Function() onListen) {}

  @override
  Future<void> saveMemory(ChatMessage input, ChatMessage output) async =>
      await memory.saveContext(
        inputValues: {'input': input.contentAsString},
        outputValues: {'output': output.contentAsString},
      );

  @override
  Future<void> saveAIMessage(AIChatMessage message) async {
    memory.chatHistory.addAIChatMessage(message.contentAsString);
  }

  @override
  void saveUserMessage(HumanChatMessage message) {
    memory.chatHistory.addHumanChatMessage(message.contentAsString);
  }

  @override
  Future<List<ChatMessage>> getHistory() async {
    Map<String, dynamic> historyMap = await memory.loadMemoryVariables();
    var memoryKey = LangchainServiceConst.defaultMemoryKey.toString();
    return historyMap.containsKey(memoryKey) ? historyMap[memoryKey] : [];
  }

  @override
  void clearMemory() async {
    await memory.clear();
  }
}
