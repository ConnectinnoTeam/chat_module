extension StringExtension on String {
  Iterable<String> expanded() sync* {
    for (var i = 0; i < length; i++) {
      yield this[i];
    }
  }
}
