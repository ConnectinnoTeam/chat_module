import 'package:json_annotation/json_annotation.dart';

enum ChatCompletionFinishReason {
  @JsonValue('null')
  nullResponse,
  @JsonValue("ChatCompletionFinishReason.model_length")
  modelLength,
  @JsonValue("ChatCompletionFinishReason.length")
  maxLength,
  @JsonValue("ChatCompletionFinishReason.stop")
  finished,
  @JsonValue("ChatCompletionFinishReason.timeout")
  timeout,
  @JsonValue('ChatCompletionFinishReason.tool_calls')
  toolCalls,
  @JsonValue('ChatCompletionFinishReason.content_filter')
  contentFilter,
  @JsonValue('ChatCompletionFinishReason.function_call')
  functionCall,
  @JsonValue("ChatCompletionFinishReason.error")
  error;
}
