import 'dart:io';

import 'package:chat_module/controller/chat_controller.dart';
import 'package:chat_module/model/concrete/chat_gpt/chat_gpt_system_prompt.dart';
import 'package:chat_module/model/concrete/chat_gpt/chat_gpt_user_prompt.dart';
import 'package:chat_module/model/concrete/request/chat_gpt_request.dart';
import 'package:chat_module/provider/concrete/chat_gpt_provider.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_initializer.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  final ChatController controller = ChatController(
    provider: ChatGptProvider.completions(
      delay: const Duration(milliseconds: 1),
      timeout: const Duration(milliseconds: 500),
      request: ChatGptRequest.turbo3_50(
        prompts: [
          ChatGptSystemPrompt(
              content: "You are cowboy and you are in the wild west")
        ],
        temperature: 0.3,
        maxToken: 50,
      ),
    ),
  );

  var str = "";
  controller.hook((message) {
    str += message;
    print(str);
  });

  controller.initialize((headers) => headers['Authorization'] =
      "Bearer YOUR-API-KEY");

  test('adds one to input values', () async {
    await controller.sendMessage(
      ChatGptUserPrompt(content: "Describe me entropy"),
    );
    print(str);
    await Future.delayed(const Duration(seconds: 10));
  });
}
