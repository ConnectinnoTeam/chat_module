// ignore_for_file: unnecessary_string_interpolations

import 'dart:async';
import 'dart:convert';

import 'package:async_queue/async_queue.dart';
import 'package:chat_module/model/abstract/base_completion_request.dart';
import 'package:chat_module/model/abstract/base_prompt.dart';
import 'package:chat_module/model/concrete/response/chat_gpt_response.dart';
import 'package:chat_module/provider/abstract/chat_provider.dart';
import 'package:chat_module/utility/extensions/stream_extensions.dart';
import 'package:chat_module/utility/extensions/string_extensions.dart';
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
      final stream = resp.data.stream as Stream<List<int>>;
      stream //
          .postProcess()
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

  Map<String, dynamic>? _convertResponse(String str) {
    try {
      final map = jsonDecode(str) as Map<String, dynamic>;
      return map;
    } catch (e) {
      return null;
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

  void _listen(List<String> event, Completer<FinishReason> completer) {
    for (var i = 0; i < event.length; i++) {
      if (_convertResponse(event[i]) == null) {
        continue;
      }
      final map = _convertResponse(event[i])!;
      final response = ChatGptResponse.fromJson(map);
      final message = response.choices?.first.delta?.content ?? '';
      _hookFeedStream.sink.add(message);
      if (response.choices?.first.finishReason != null) {
        completer.complete(response.choices!.first.finishReason!);
      }
    }
  }

  void _dioConfig(Dio dio) {
    dio.options.baseUrl = baseUrl;
    dio.options.responseType = ResponseType.stream;
    dio.options.contentType = Headers.jsonContentType;
  }
}
