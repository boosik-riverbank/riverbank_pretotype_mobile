import 'package:riverbank_pretotype_mobile/exchange/model/exchange_rate.dart';
import 'package:riverbank_pretotype_mobile/exchange/service/exchange_rate_service.dart';

class ExchangeRateRepository {
  // Singleton
  ExchangeRateRepository._privateConstructor();
  static final ExchangeRateRepository _instance = ExchangeRateRepository._privateConstructor();
  factory ExchangeRateRepository() {
    return _instance;
  }

  final ExchangeRateService _service = ExchangeRateService();
  // TODO : move to cache
  List<ExchangeRate>? _rateList;
  int _lastUpdated = 0;
  bool _needToBeUpdated = false;

  Future<void> init() async {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (_rateList == null) {
      // not initialized
      await _loadFromServiceAndUpdateTimestamp(now);
    } else if (now - _lastUpdated > 36000000) {
      // need to update
      await _loadFromServiceAndUpdateTimestamp(now);
    } else if (_needToBeUpdated) {
      await _loadFromServiceAndUpdateTimestamp(now);
    }
  }

  Future<ExchangeRate> getExchangeRate(String currency) async {
    await init();
    return _rateList!.firstWhere((rate) => rate.currency == currency);
  }

  Future<void> _loadFromServiceAndUpdateTimestamp(int now) async {
    _rateList = await _service.getExchangeRate();
    _lastUpdated = now;
    _needToBeUpdated = false;
  }

  void setNeedToBeUpdated(bool flag) {
    _needToBeUpdated = flag;
  }
}