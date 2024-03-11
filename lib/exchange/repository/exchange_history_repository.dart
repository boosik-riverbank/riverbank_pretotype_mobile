import 'package:riverbank_pretotype_mobile/exchange/service/exchange_history_service.dart';

class ExchangeHistoryRepository {
  ExchangeHistoryRepository._privateConstructor();
  static final ExchangeHistoryRepository _instance = ExchangeHistoryRepository._privateConstructor();
  factory ExchangeHistoryRepository() {
    return _instance;
  }

  final ExchangeHistoryService _service = ExchangeHistoryService();

}