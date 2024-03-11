import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:riverbank_pretotype_mobile/balance/service/balance_service.dart';
import 'package:riverbank_pretotype_mobile/logger/logger.dart';
import 'package:riverbank_pretotype_mobile/withdrawal/service/withdrawal_service.dart';

import '../model/balance.dart';

class BalanceRepository {
  BalanceRepository._privateConstructor();

  static final BalanceRepository _instance = BalanceRepository._privateConstructor();

  factory BalanceRepository() {
    return _instance;
  }

  final _balanceService = BalanceService();
  final _withdrawalService = WithdrawalService();
  var balance = Balance(currency: 'KRW', amount: 0).obs;

  Future<void> getBalance(String userId, String currency) async {
    logger.i('getBalance: $userId, $currency');
    final result = await _balanceService.get(userId, currency);
    balance.value = result;
  }

  Future<void> withdraw(String userId, String currency, int amount) async {
    logger.i('withdraw: $userId, $currency, $amount');
    final result = await _withdrawalService.withdraw(userId, currency, amount);
    balance.value = result;
  }
}