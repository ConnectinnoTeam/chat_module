import 'package:chat_module/model/abstract/base_prompt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_gpt_user_prompt.g.dart';

@JsonSerializable()
class ChatGptUserPrompt extends BasePrompt<ChatGptUserPrompt> {
  @override
  final String content;

  ChatGptUserPrompt({
    required this.content,
  });

  @override
  ChatGptUserPrompt fromJson(Map<String, dynamic> json) =>
      _$ChatGptUserPromptFromJson(json);

  @JsonKey(includeToJson: true)
  @override
  String get role => 'user';

  @override
  Map<String, dynamic> toJson() => _$ChatGptUserPromptToJson(this);
}
