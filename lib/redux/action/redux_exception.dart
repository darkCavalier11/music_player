// ignore_for_file: public_member_api_docs, sort_constructors_first
class ReduxException implements Exception {
  final String errorMessage;
  final String actionName;
  ReduxException({
    required this.errorMessage,
    required this.actionName,
  });
}
