class ApiRequestException implements Exception {
  final int statusCode;
  final String errorMessage;

  ApiRequestException(this.statusCode, this.errorMessage);
}