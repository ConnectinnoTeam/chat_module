import 'package:chat_module/model/abstract/base_prompt.dart';
import 'package:chat_module/model/concrete/response/chat_gpt_response.dart';
import 'package:chat_module/provider/abstract/chat_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ChatController extends ChangeNotifier {
  final Dio _dio = Dio();

  final ChatProvider provider;

  ChatController({
    required this.provider,
  });

  void initialize(void Function(Map<String, dynamic> headers) config) {
    config(_dio.options.headers);
  }

  Future<FinishReason?> sendMessage<T extends BasePrompt<T>>(T prompt) async {
    return provider.sendMessage(_dio, prompt);
  }

  void hook({
    void Function(String message)? hook,
    void Function()? onDone,
  }) {
    provider.messageHook = hook;
    provider.messageHookDone = onDone;
  }
}
