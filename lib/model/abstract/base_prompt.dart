abstract class BasePrompt<T extends BasePrompt<T>> {
  String get role;
  String get content;
  const BasePrompt();

  Map<String, dynamic> toJson();
  T fromJson(Map<String, dynamic> json);
}
