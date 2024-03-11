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
    required this.isFinalized,
    required this.method,
    required this.finalizedAt,
    required this.sns,
  });

  final String id;
  final String? createdAt;
  final String? finalizedAt;
  final String originalCurrency;
  final int originalAmount;
  final String targetCurrency;
  final int targetAmount;
  final double appliedExchangeRate;
  final String feeCurrency;
  final int fee;
  final String userId;
  final bool isFinalized;
  final String? sns;
  final String? method;

  factory ExchangeHistory.fromJson(Map json) {
    print(json);
    return ExchangeHistory(
      id: json['id'],
      createdAt: json['createdAt'],
      finalizedAt: json['finalizedAt'],
      originalCurrency: json['originalCurrency'],
      originalAmount: json['originalAmount'],
      targetCurrency: json['targetCurrency'],
      targetAmount: json['targetAmount'],
      appliedExchangeRate: json['appliedExchangeRate'],
      feeCurrency: json['feeCurrency'],
      fee: json['fee'],
      userId: json['userId'],
      isFinalized: json['isFinalized'],
      sns: json['sns'],
      method: json['method']
    );
  }
}