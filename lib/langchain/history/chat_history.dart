import 'package:langchain/langchain.dart';
import 'package:uuid/uuid.dart';

class ChatHistory {
  final String id;
  final String title;
  final List<ChatMessage> messages;

  ChatHistory({String? id, String? title, List<ChatMessage>? messages})
      : id = id ?? const Uuid().v4(),
        title = title ?? '',
        messages = messages ?? [];

  void clearHistory() => messages.clear();

  void removeLastMessage() {
    if (messages.isNotEmpty) {
      messages.removeLast();
    }
  }

  void removeFirstMessage() {
    if (messages.isNotEmpty) {
      messages.removeAt(0);
    }
  }
}
