import 'dart:convert';

extension StreamPostProcessExt on Stream<List<int>> {
  Stream<List<String>> postProcess() {
    return map((event) {
      final respStr = utf8.decode(event);
      return respStr.replaceAll('data:', '').trim();
    }).map(const LineSplitter().convert);
  }
}
