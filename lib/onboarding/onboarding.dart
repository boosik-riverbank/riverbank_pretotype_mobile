import 'package:logger/logger.dart';
import 'package:riverbank_pretotype_mobile/balance/repository/balance_repository.dart';
import 'package:riverbank_pretotype_mobile/common/env.dart';
import 'package:riverbank_pretotype_mobile/exchange/model/exchange_rate.dart';
import 'package:riverbank_pretotype_mobile/exchange/repository/exchage_rate_repository.dart';
import 'package:riverbank_pretotype_mobile/logger/logger.dart';
import 'package:riverbank_pretotype_mobile/login/repository/user_repository.dart';
import 'package:riverbank_pretotype_mobile/login/service/login_service.dart';
import 'package:riverbank_pretotype_mobile/login/service/user_service.dart';

class Onboarding {
  Future<bool> onboardData() async {
    if (devMode) {
      Logger.level = Level.debug;
    } else {
      Logger.level = Level.info;
    }
    logger.d('Onboarding start!');
    logger.d('Exchange rate loading start.');
    await ExchangeRateRepository().init();

    logger.d('User loading start.');
    final user = await UserServiceFactory().createUserServiceInstance().getByPreference();

    logger.d('User loading finish: $user');
    if (user != null) {
      logger.d('User ${user.id} info is already saved in preference');
      final isSignedUp = await LoginService().isSignedUp(user.email);
      if (isSignedUp) {
        logger.d('User ${user.id} is already signed up.');
        await UserRepository().init(user.id);
        await BalanceRepository().getBalance(user.id, 'KRW');
        return true;
      } else {
        logger.d('User ${user.id} is not signed up yet.');
      }
    }

    logger.d('This user need to sign up.');
    return false;
  }
}