import 'dart:convert';

import 'package:riverbank_pretotype_mobile/balance/model/balance.dart';

import 'package:http/http.dart' as http;

abstract class IBalanceService {
  Future<Balance> get(String userId, String currency);
  Future<void> withdraw(String userId, String currency, int amount);
}

class BalanceService implements IBalanceService {
  @override
  Future<Balance> get(String userId, String currency) async {
    var uri = Uri.parse('https://api-dev.riverbank.world/v1/balance/$userId?currency=$currency');
    var response = await http.get(uri, headers: {
      'Content-Type': 'application/json'
    });
    var jsonData = jsonDecode(response.body);
    print(jsonData);
    var result = Balance(currency: jsonData[0]['currency'], amount: jsonData[0]['amount']);
    return result;
  }

  @override
  Future<void> withdraw(String userId, String currency, int amount) async {
    final uri = Uri.parse('https://api-dev.riverbank.world/v1/withdrawalHistory');
    await http.post(uri, headers: {
      'Content-Type': 'application/json'
    }, body: jsonEncode({
      'user_id': userId,
      'currency': currency,
      'amount': amount,
    }));
  }
}

