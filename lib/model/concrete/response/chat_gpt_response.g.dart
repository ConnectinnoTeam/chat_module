// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_gpt_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatGptResponse _$ChatGptResponseFromJson(Map<String, dynamic> json) =>
    ChatGptResponse(
      id: json['id'] as String?,
      object: json['object'] as String?,
      created: json['created'] as int?,
      model: json['model'] as String?,
      systemFingerprint: json['system_fingerprint'] as String?,
      choices: (json['choices'] as List<dynamic>?)
          ?.map((e) => Choices.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChatGptResponseToJson(ChatGptResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'object': instance.object,
      'created': instance.created,
      'model': instance.model,
      'system_fingerprint': instance.systemFingerprint,
      'choices': instance.choices,
    };

Choices _$ChoicesFromJson(Map<String, dynamic> json) => Choices(
      index: json['index'] as int?,
      delta: json['delta'] == null
          ? null
          : Delta.fromJson(json['delta'] as Map<String, dynamic>),
      finishReason:
          $enumDecodeNullable(_$FinishReasonEnumMap, json['finish_reason']),
    );

Map<String, dynamic> _$ChoicesToJson(Choices instance) => <String, dynamic>{
      'index': instance.index,
      'delta': instance.delta,
      'finish_reason': _$FinishReasonEnumMap[instance.finishReason],
    };

const _$FinishReasonEnumMap = {
  FinishReason.maxLength: 'length',
  FinishReason.finished: 'stop',
  FinishReason.timeout: 'timeout',
};

Delta _$DeltaFromJson(Map<String, dynamic> json) => Delta(
      content: json['content'] as String?,
    );

Map<String, dynamic> _$DeltaToJson(Delta instance) => <String, dynamic>{
      'content': instance.content,
    };
