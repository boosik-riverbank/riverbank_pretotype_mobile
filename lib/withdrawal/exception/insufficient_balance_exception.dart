class InsufficientBalanceException implements Exception {
  String cause;

  InsufficientBalanceException(this.cause);
}