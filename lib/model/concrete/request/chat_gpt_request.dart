import 'package:chat_module/model/abstract/base_completion_request.dart';
import 'package:chat_module/model/abstract/base_prompt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_gpt_request.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class ChatGptRequest extends BaseCompletionRequest<ChatGptRequest> {
  ChatGptRequest({
    required this.model,
    required this.temperature,
    required this.maxTokens,
  });

  @override
  final String model;

  @override
  final double temperature;

  @JsonKey(includeToJson: true, includeFromJson: false, name: 'messages')
  @override
  List<BasePrompt<dynamic>> defaultPrompts = [];

  @override
  final int maxTokens;

  @JsonKey(includeToJson: true)
  final bool stream = true;

  @override
  BaseCompletionRequest fromJson(Map<String, dynamic> json) =>
      _$ChatGptRequestFromJson(json);

  @override
  Map<String, dynamic> toJson() {
    final json = _$ChatGptRequestToJson(this);
    json['messages'] = defaultPrompts.map((e) => e.toJson()).toList();
    return json;
  }

  factory ChatGptRequest.turbo3_50({
    required List<BasePrompt> prompts,
    required double temperature,
    required int maxToken,
  }) {
    final request = ChatGptRequest(
      model: "gpt-3.5-turbo-1106",
      temperature: temperature,
      maxTokens: maxToken,
    );
    request.defaultPrompts = prompts;
    return request;
  }

  factory ChatGptRequest.turbo4({
    required List<BasePrompt> prompts,
    required double temperature,
    required int maxToken,
  }) {
    final request = ChatGptRequest(
      model: 'gpt-4-turbo',
      temperature: temperature,
      maxTokens: maxToken,
    );
    request.defaultPrompts = prompts;
    return request;
  }

  @override
  ChatGptRequest copyWith({
    String? model,
    double? temperature,
    List<BasePrompt>? prompts,
    int? maxToken,
  }) {
    final newPrompts = List<BasePrompt>.from(defaultPrompts + (prompts ?? []));
    final request = ChatGptRequest(
      model: model ?? this.model,
      temperature: temperature ?? this.temperature,
      maxTokens: maxToken ?? maxTokens,
    );
    request.defaultPrompts = newPrompts;
    return request;
  }
}
