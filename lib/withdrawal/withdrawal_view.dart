import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:riverbank_pretotype_mobile/balance/repository/balance_repository.dart';
import 'package:riverbank_pretotype_mobile/login/repository/user_repository.dart';
import 'package:riverbank_pretotype_mobile/withdrawal/domain/withdrawal.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WithdrawalPage extends StatefulWidget {
  const WithdrawalPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WithdrawalPageState();
  }

}

class _WithdrawalPageState extends State<WithdrawalPage> {
  final _textController = TextEditingController(text: '0');
  @override
  Widget build(BuildContext context) {
    final userRepository = UserRepository();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.withdraw, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        actions: [
          IconButton(
              onPressed: () {
                context.push("/translation");
              },
              icon: const Icon(Icons.g_translate_outlined, color: Colors.black))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Image.asset('asset/image/atm.png', width: 200,),
            ),
            TextField(
              controller: _textController,
              keyboardType: TextInputType.number,
            ),
            Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 32),
                decoration: BoxDecoration(
                    color: const Color(0xff3929b7),
                    borderRadius: BorderRadius.circular(15)
                ),
                child: CupertinoButton(
                    onPressed: () {
                      final user = userRepository.getSavedUser();
                      if (user != null) {
                        Withdrawal().doWithdraw(BalanceRepository(), user.id, 'KRW', int.parse(_textController.text)).then((_) {
                          Fluttertoast.showToast(msg: 'Withdraw success!');
                          context.go('/balance');
                        });
                      }
                    },
                    child: Center(
                        child: Text(AppLocalizations.of(context)!.withdraw, style: TextStyle(color: Colors.white, fontSize: 20))
                    )
                )
            )
          ],
        ),
      ),
    );
  }

}