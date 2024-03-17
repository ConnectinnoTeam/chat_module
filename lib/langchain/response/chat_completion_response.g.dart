// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_completion_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatCompletionResponse _$ChatCompletionResponseFromJson(
        Map<String, dynamic> json) =>
    ChatCompletionResponse(
      text: json['text'] as String?,
      finishReason: $enumDecodeNullable(
          _$ChatCompletionFinishReasonEnumMap, json['finish_reason']),
    );

Map<String, dynamic> _$ChatCompletionResponseToJson(
        ChatCompletionResponse instance) =>
    <String, dynamic>{
      'text': instance.text,
      'finish_reason':
          _$ChatCompletionFinishReasonEnumMap[instance.finishReason],
    };

const _$ChatCompletionFinishReasonEnumMap = {
  ChatCompletionFinishReason.nullResponse: 'null',
  ChatCompletionFinishReason.modelLength:
      'ChatCompletionFinishReason.model_length',
  ChatCompletionFinishReason.maxLength: 'ChatCompletionFinishReason.length',
  ChatCompletionFinishReason.finished: 'ChatCompletionFinishReason.stop',
  ChatCompletionFinishReason.timeout: 'ChatCompletionFinishReason.timeout',
  ChatCompletionFinishReason.toolCalls: 'ChatCompletionFinishReason.tool_calls',
  ChatCompletionFinishReason.contentFilter:
      'ChatCompletionFinishReason.content_filter',
  ChatCompletionFinishReason.functionCall:
      'ChatCompletionFinishReason.function_call',
  ChatCompletionFinishReason.error: 'ChatCompletionFinishReason.error',
};
