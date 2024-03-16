import 'package:chat_module/langchain/response/chat_finish_reasons.dart';
import 'package:json_annotation/json_annotation.dart';
part 'chat_completion_response.g.dart';

@JsonSerializable()
class ChatCompletionResponse {
  final String? text;
  @JsonKey(name: 'finish_reason', unknownEnumValue: null)
  final ChatCompletionFinishReason? finishReason;

  ChatCompletionResponse({
    this.text,
    this.finishReason,
  });

  factory ChatCompletionResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatCompletionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatCompletionResponseToJson(this);
}
