import 'package:chat_module/model/abstract/base_prompt.dart';

abstract class BaseCompletionRequest<T extends BaseCompletionRequest<T>> {
  const BaseCompletionRequest();
  String get model;
  double get temperature;
  List<BasePrompt<dynamic>>? get defaultPrompts;
  int get maxTokens;

  Map<String, dynamic> toJson();
  BaseCompletionRequest fromJson(Map<String, dynamic> json);

  T copyWith({
    String? model,
    double? temperature,
    List<BasePrompt>? prompts,
    int? maxToken,
  });
}
