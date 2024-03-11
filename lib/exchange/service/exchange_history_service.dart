import 'dart:convert';

import 'package:riverbank_pretotype_mobile/exchange/model/exchange_history.dart';
import 'package:http/http.dart' as http;
import 'package:riverbank_pretotype_mobile/logger/logger.dart';

abstract class IExchangeHistoryService {
  Future<List<ExchangeHistory>> getExchangeHistoriesById(String userId);
  Future<void> uploadExchangeData(ExchangeHistory exchangeHistory);
}

class ExchangeHistoryService implements IExchangeHistoryService {
  @override
  Future<List<ExchangeHistory>> getExchangeHistoriesById(String userId) async {
    try {
      logger.d('getExchangeHistoriesById, $userId');
      var uri = Uri.parse('https://api-dev.riverbank.world/v1/exchangeHistory/$userId');
      var response = await http.get(uri);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes));

      return decodedResponse.map<ExchangeHistory>((item) => ExchangeHistory.fromJson(item)).toList();
    } catch (err) {
      logger.e('error=${err.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> uploadExchangeData(ExchangeHistory exchangeHistory) async {
    var uri = Uri.parse('https://api-dev.riverbank.world/v1/exchangeHistory');
    await http.post(uri, headers: {"Content-Type": "application/json"}, body: jsonEncode({
      'original_currency': exchangeHistory.originalCurrency,
      'original_amount': exchangeHistory.originalAmount.toString(),
      'target_currency': exchangeHistory.targetCurrency,
      'target_amount': exchangeHistory.targetAmount.toString(),
      'applied_exchange_rate': exchangeHistory.appliedExchangeRate.toString(),
      'fee_currency': exchangeHistory.feeCurrency,
      'fee': exchangeHistory.fee.toString(),
      'user_id': exchangeHistory.userId,
      'is_finalized': exchangeHistory.isFinalized,
      'sns': exchangeHistory.sns,
      'method': exchangeHistory.method,
    }));
  }
}