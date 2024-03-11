import 'package:riverbank_pretotype_mobile/exchange/model/exchange_history.dart';

class ExchangeStore {
  ExchangeStore._privateConstructor();

  static final ExchangeStore _instance = ExchangeStore._privateConstructor();

  factory ExchangeStore() {
    return _instance;
  }

  String? _originalCurrency;
  String? _targetCurrency;
  int _originalAmount = 0;
  int _targetAmount = 0;
  int _fee = 0;
  String? _feeCurrency;
  double _appliedExchangeRate = 0.0;
  String? _userId;
  bool _isFinalized = false;
  String? _sns;
  String? _method;

  String? getUserId() {
    return _userId;
  }

  String? getOriginCurrency() {
    return _originalCurrency;
  }

  String? getTargetCurrency() {
    return _targetCurrency;
  }

  int getOriginAmount() {
    return _originalAmount;
  }

  int getTargetAmount() {
    return _targetAmount;
  }

  int getFee() {
    return _fee;
  }

  String? getFeeCurrency() {
    return _feeCurrency;
  }

  double getAppliedExchangeRate() {
    return _appliedExchangeRate;
  }

  String? getSns() {
    return _sns;
  }

  bool isFinalized() {
    return _isFinalized;
  }

  String? getMethod() {
    return _method;
  }

  void setOriginCurrency(String originCurrency) {
    _originalCurrency = originCurrency;
  }

  void setOriginAmount(int originAmount) {
    _originalAmount = originAmount;
  }

  void setTargetCurrency(String targetCurrency) {
    _targetCurrency = targetCurrency;
  }

  void setTargetAmount(int targetAmount) {
    _targetAmount = targetAmount;
  }

  void setFee(int fee) {
    _fee = fee;
  }

  void setFeeCurrency(String feeCurrency) {
    _feeCurrency = feeCurrency;
  }

  void setAppliedExchangeRate(double appliedExchangeRate) {
    _appliedExchangeRate = appliedExchangeRate;
  }

  void setUserId(String userId) {
    _userId = userId;
  }

  void setIsFinalized(bool flag) {
    _isFinalized = flag;
  }

  void setSns(String sns) {
    _sns = sns;
  }

  void setMethod(String method) {
    _method = method;
  }

  ExchangeHistory toExchangeData() {
    return ExchangeHistory(
        id: '',
        createdAt: null,
        finalizedAt: null,
        originalCurrency: _originalCurrency ?? '',
        originalAmount: _originalAmount,
        targetCurrency: _targetCurrency ?? '',
        targetAmount: _targetAmount,
        appliedExchangeRate: _appliedExchangeRate,
        feeCurrency: _feeCurrency ?? '',
        fee: _fee,
        userId: _userId!,
        isFinalized: _isFinalized,
        sns: _sns,
        method: _method ?? '');
  }

  @override
  String toString() {
    return toJson().toString();
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['original_currency'] = _originalCurrency;
    map['original_amount'] = _originalAmount;
    map['target_currency'] = _targetCurrency;
    map['target_amount'] = _targetAmount;
    map['fee'] = _fee;
    map['fee_currency'] = _feeCurrency;
    map['applied_exchange_rate'] = _appliedExchangeRate;
    map['user_id'] = _userId;
    map['is_finalized'] = _isFinalized;
    map['sns'] = _sns;
    map['method'] = _method;
    return map;
  }
}