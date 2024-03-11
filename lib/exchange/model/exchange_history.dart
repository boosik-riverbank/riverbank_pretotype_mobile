class ExchangeHistory {
  const ExchangeHistory({
    required this.id,
    required this.createdAt,
    required this.originalCurrency,
    required this.originalAmount,
    required this.targetCurrency,
    required this.targetAmount,
    required this.appliedExchangeRate,
    required this.feeCurrency,
    required this.fee,
    required this.userId,
  });

  final String id;
  final String? createdAt;
  final String originalCurrency;
  final int originalAmount;
  final String targetCurrency;
  final int targetAmount;
  final double appliedExchangeRate;
  final String feeCurrency;
  final int fee;
  final String userId;

  factory ExchangeHistory.fromJson(Map json) {
    return ExchangeHistory(
      id: json['id'],
      createdAt: json['createdAt'],
      originalCurrency: json['originalCurrency'],
      originalAmount: json['originalAmount'],
      targetCurrency: json['targetCurrency'],
      targetAmount: json['targetAmount'],
      appliedExchangeRate: json['appliedExchangeRate'],
      feeCurrency: json['feeCurrency'],
      fee: json['fee'],
      userId: json['userId']
    );
  }
}