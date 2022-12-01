// ignore_for_file: public_member_api_docs, sort_constructors_first
class ReduxException implements Exception {
  final String errorMessage;
  final String actionName;
  final String? userErrorToastMessage;
  ReduxException({
    required this.errorMessage,
    required this.actionName,
    this.userErrorToastMessage,
  });
}
