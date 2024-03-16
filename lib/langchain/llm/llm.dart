import 'package:langchain/langchain.dart';

class LLM {
  const LLM(
    this.model,
    this.embeddings,
  );
  final dynamic model;
  final Embeddings embeddings;
}
