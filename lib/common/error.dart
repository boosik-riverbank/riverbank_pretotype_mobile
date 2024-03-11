class DuplicateEmailException implements Exception {
  String cause;
  DuplicateEmailException(this.cause);
}