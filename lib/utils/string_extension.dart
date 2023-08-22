extension StringExt on String? {
  bool get isNullOrEmpty {
    return this == null || this == '';
  }
}