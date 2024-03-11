import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:riverbank_pretotype_mobile/exchange/model/exchange_rate.dart';

abstract class IExchangeRateService {
  Future<List<ExchangeRate>> getExchangeRate();
}

class ExchangeRateService implements IExchangeRateService {
  @override
  Future<List<ExchangeRate>> getExchangeRate() async {
    String rawResult = (await http.get(Uri.parse("https://mqyzukd700.execute-api.ap-northeast-2.amazonaws.com/v1/rate"))).body;
    List<dynamic> json = jsonDecode(rawResult);
    List<ExchangeRate> list = json.map((item) => ExchangeRate.fromJson(item)).toList();
    return list;
  }
}