class ExchangeRate {
  final String currency;
  final double value;
  final int krwStandard;

  ExchangeRate({
    required this.currency,
    required this.value,
    required this.krwStandard
  });

  factory ExchangeRate.fromJson(Map<String, dynamic> json) {
    return ExchangeRate(currency: json['currency'], value: json['value'], krwStandard: json['krwStandard']);
  }
}