// ignore_for_file: unnecessary_string_interpolations

import 'dart:async';
import 'dart:convert';

import 'package:async_queue/async_queue.dart';
import 'package:chat_module/model/abstract/base_completion_request.dart';
import 'package:chat_module/model/abstract/base_prompt.dart';
import 'package:chat_module/model/concrete/response/chat_gpt_response.dart';
import 'package:chat_module/provider/abstract/chat_provider.dart';
import 'package:chat_module/utility/extensions/string_extensions.dart';
import 'package:chat_module/utility/transformers/stream_transformers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ChatGptProvider extends ChatProvider {
  @override
  final String baseUrl = 'https://api.openai.com/v1/chat';

  @override
  final String endPoint;

  @override
  final Duration delay;

  @override
  final Duration timeout;

  @override
  final BaseCompletionRequest request;

  ChatGptProvider({
    required this.endPoint,
    required this.request,
    required this.delay,
    required this.timeout,
  }) {
    _hookFeedStream.stream.listen(_feedHook);
  }

  factory ChatGptProvider.completions({
    required BaseCompletionRequest request,
    required Duration delay,
    required Duration timeout,
  }) =>
      ChatGptProvider(
        delay: delay,
        timeout: timeout,
        endPoint: '/completions',
        request: request,
      );

  final StreamController<String> _hookFeedStream = StreamController<String>();

  final _queue = AsyncQueue.autoStart();

  @override
  Future<FinishReason?> sendMessage<T extends BasePrompt<T>>(
    Dio dio,
    T prompt,
  ) async {
    _dioConfig(dio);
    final newRequest = request.copyWith(prompts: [prompt]);
    try {
      final Completer<FinishReason> completer = Completer();
      final resp = await dio.post(endPoint, data: newRequest.toJson());
      final stream = resp.data.stream;
      stream
          .transform(uint8Transformer)
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .transform(chatGptResponseTransformer)
          .timeout(
            timeout,
            onTimeout: (_) => completer.complete(FinishReason.timeout),
          )
          .listen((data) => _listen(data, completer))
          .onDone(() {
        if (completer.isCompleted) return;
        completer.complete(FinishReason.finished);
      });
      return completer.future;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return FinishReason.error;
    }
  }

  @override
  void dispose() {
    _hookFeedStream.close();
  }

  void _feedHook(String message) {
    _queue.addJob((_) async {
      final yielded = message.expanded();
      for (final char in yielded) {
        await Future.delayed(delay);
        messageHook?.call(char);
      }
    });
  }

  void _listen(ChatGptResponse? response, Completer<FinishReason> completer) {
    if (response == null) return;
    final message = response.choices?.first.delta?.content ?? '';
    if (response.choices?.first.finishReason != null) {
      completer.complete(response.choices!.first.finishReason!);
    }
    _hookFeedStream.sink.add(message);
  }

  void _dioConfig(Dio dio) {
    dio.options.baseUrl = baseUrl;
    dio.options.responseType = ResponseType.stream;
    dio.options.contentType = Headers.jsonContentType;
  }
}
