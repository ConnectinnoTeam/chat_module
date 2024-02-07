import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:chat_module/model/concrete/response/chat_gpt_response.dart';

StreamTransformer<Uint8List, List<int>> uint8Transformer =
    StreamTransformer.fromHandlers(
  handleData: (data, sink) {
    sink.add(List<int>.from(data));
  },
);

StreamTransformer<String, ChatGptResponse?> chatGptResponseTransformer =
    StreamTransformer.fromHandlers(
  handleData: (data, sink) {
    if (data.isNotEmpty) {
      final jsonString = data.replaceAll('data: ', '');
      final json = jsonDecode(jsonString);
      sink.add(ChatGptResponse.fromJson(json));
    }
    sink.add(null);
  },
);
