import 'package:riverbank_pretotype_mobile/balance/repository/balance_repository.dart';
import 'package:riverbank_pretotype_mobile/exchange/service/exchange_history_service.dart';
import 'package:riverbank_pretotype_mobile/exchange/store/exchange_store.dart';

class Exchanging {
  Future<void> doExchange(ExchangeHistoryService exchangeHistoryService, BalanceRepository balanceRepository, ExchangeStore exchangeStore) async {
    await exchangeHistoryService.uploadExchangeData(exchangeStore.toExchangeData());
    await balanceRepository.getBalance(exchangeStore.getUserId()!, 'KRW');
  }
}