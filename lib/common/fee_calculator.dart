class FeeAndExchanged {
  FeeAndExchanged({required this.fee, required this.exchanged});

  int fee;
  int exchanged;
}

class FeeCalculator {
  // fee rate = 1%
  static FeeAndExchanged calculateWithFee(int amount) {
    int removeFee = (amount * 0.99).floor();
    int removeDigit = (removeFee / 100).floor();
    int result = removeDigit * 100;

    return FeeAndExchanged(fee: amount - result, exchanged: result);
  }
}