class QueryBuilderException implements Exception {
  /// A message describing the format error.
  final String message;

  QueryBuilderException(this.message);
}
