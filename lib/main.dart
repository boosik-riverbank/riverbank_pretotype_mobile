import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverbank_pretotype_mobile/balance/balance_view.dart';
import 'package:riverbank_pretotype_mobile/bill/billing_view.dart';
import 'package:riverbank_pretotype_mobile/bill/billing_method_view.dart';
import 'package:riverbank_pretotype_mobile/bill/in_person_billing_view.dart';
import 'package:riverbank_pretotype_mobile/exchange/exchange_history_view.dart';
import 'package:riverbank_pretotype_mobile/exchange/exchange_view.dart';
import 'package:riverbank_pretotype_mobile/bill/billing_result_view.dart';
import 'package:riverbank_pretotype_mobile/login/login_view.dart';
import 'package:riverbank_pretotype_mobile/onboarding/onboarding_view.dart';
import 'package:riverbank_pretotype_mobile/translate/translate_view.dart';
import 'package:riverbank_pretotype_mobile/withdrawal/withdrawal_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const RiverBankApp());
}

class ResultPageParameter {
  ResultPageParameter({
    required this.meetingTime,
    required this.meetingPlace,
    required this.snsContact,
  });

  String meetingTime;
  String meetingPlace;
  String snsContact;
}

class RiverBankApp extends StatelessWidget {
  const RiverBankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: GoRouter(
        initialLocation: '/splash',
        routes: [
          GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
          GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
          GoRoute(path: '/balance', builder: (context, state) => const BalancePage()),
          GoRoute(path: '/exchange', builder: (context, state) => const ExchangePage()),
          GoRoute(path: '/exchange_history', builder: (context, state) => const ExchangeHistoryPage()),
          GoRoute(path: '/receipt', builder: (context, state) => const BillPage()),
          GoRoute(path: '/result', builder: (context, state) => const ResultPage()),
          GoRoute(path: '/bill_method', builder: (context, state) => const BillMethodPage()),
          GoRoute(path: '/translation', builder: (context, state) => const TranslationPage()),
          GoRoute(path: '/withdrawal', builder: (context, state) => const WithdrawalPage()),
          GoRoute(path: '/in_person', builder: (context, state) => const InPersonBillingPage(restorationId: 'in_person',)),
        ],
      ),
      title: 'Riverbank',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
