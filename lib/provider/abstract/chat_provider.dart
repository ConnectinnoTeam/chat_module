import 'package:chat_module/model/abstract/base_completion_request.dart';
import 'package:chat_module/model/abstract/base_prompt.dart';
import 'package:chat_module/model/concrete/response/chat_gpt_response.dart';
import 'package:dio/dio.dart';

abstract class ChatProvider {
  String get baseUrl;
  String get endPoint;

  BaseCompletionRequest get request;

  Duration get timeout;

  Duration get delay;

  void Function(String message)? messageHook;

  Future<FinishReason?> sendMessage<R extends BasePrompt<R>>(Dio dio, R prompt);

  void dispose();
}
