import 'package:chat_module/model/abstract/base_prompt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_gpt_system_prompt.g.dart';

@JsonSerializable()
class ChatGptSystemPrompt extends BasePrompt<ChatGptSystemPrompt> {
  @JsonKey(includeToJson: true)
  @override
  final String role = 'system';

  @override
  final String content;

  ChatGptSystemPrompt({
    required this.content,
  });

  @override
  ChatGptSystemPrompt fromJson(Map<String, dynamic> json) =>
      _$ChatGptSystemPromptFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ChatGptSystemPromptToJson(this);

  factory ChatGptSystemPrompt.fromJson(Map<String, dynamic> json) =>
      _$ChatGptSystemPromptFromJson(json);
}
