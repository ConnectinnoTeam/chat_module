import 'package:json_annotation/json_annotation.dart';

part 'chat_gpt_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ChatGptResponse {
  String? id;
  String? object;
  int? created;
  String? model;
  String? systemFingerprint;
  List<Choices>? choices;

  ChatGptResponse({
    this.id,
    this.object,
    this.created,
    this.model,
    this.systemFingerprint,
    this.choices,
  });

  factory ChatGptResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatGptResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChatGptResponseToJson(this);

  ChatGptResponse copyWith({
    String? id,
    String? object,
    int? created,
    String? model,
    String? systemFingerprint,
    List<Choices>? choices,
  }) {
    return ChatGptResponse(
      id: id ?? this.id,
      object: object ?? this.object,
      created: created ?? this.created,
      model: model ?? this.model,
      systemFingerprint: systemFingerprint ?? this.systemFingerprint,
      choices: choices ?? this.choices,
    );
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Choices {
  int? index;
  Delta? delta;
  FinishReason? finishReason;

  Choices({
    this.index,
    this.delta,
    this.finishReason,
  });

  factory Choices.fromJson(Map<String, dynamic> json) =>
      _$ChoicesFromJson(json);

  Map<String, dynamic> toJson() => _$ChoicesToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Delta {
  String? content;

  Delta({
    this.content,
  });

  factory Delta.fromJson(Map<String, dynamic> json) => _$DeltaFromJson(json);

  Map<String, dynamic> toJson() => _$DeltaToJson(this);

  Delta copyWith({
    String? content,
  }) {
    return Delta(
      content: content ?? this.content,
    );
  }
}

enum FinishReason {
  @JsonValue("length")
  maxLength,
  @JsonValue("stop")
  finished,
  @JsonValue("timeout")
  timeout,
  @JsonValue("error")
  error;
}
