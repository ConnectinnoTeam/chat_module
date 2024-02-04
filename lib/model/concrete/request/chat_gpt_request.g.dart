// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_gpt_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatGptRequest _$ChatGptRequestFromJson(Map<String, dynamic> json) =>
    ChatGptRequest(
      model: json['model'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      maxTokens: json['max_tokens'] as int,
    );

Map<String, dynamic> _$ChatGptRequestToJson(ChatGptRequest instance) =>
    <String, dynamic>{
      'model': instance.model,
      'temperature': instance.temperature,
      'messages': instance.defaultPrompts.map((e) => e.toJson()).toList(),
      'max_tokens': instance.maxTokens,
      'stream': instance.stream,
    };
