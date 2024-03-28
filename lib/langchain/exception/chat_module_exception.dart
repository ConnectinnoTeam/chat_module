import 'package:chat_module/langchain/exception/chat_module_exception_type.dart';
import 'package:langchain_openai/langchain_openai.dart';

final class ChatModuleException implements Exception {
  final String message;
  final int? code;
  final ChatModuleExceptionType type;
  final bool shouldRetry;

  ChatModuleException({
    required this.message,
    required this.type,
    this.shouldRetry = false,
    this.code,
  });

  factory ChatModuleException.fromChatAIException(
    OpenAIClientException exception,
  ) {
    return ChatModuleException(
      message: exception.message,
      code: exception.code,
      type: ChatModuleExceptionType.chatOpenAI,
      shouldRetry: exception.code == 429,
    );
  }
}
