import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:riverbank_pretotype_mobile/balance/repository/balance_repository.dart';
import 'package:riverbank_pretotype_mobile/balance/service/balance_service.dart';
import 'package:riverbank_pretotype_mobile/common/color.dart';
import 'package:riverbank_pretotype_mobile/common/number_formatter.dart';
import 'package:riverbank_pretotype_mobile/exchange/store/exchange_store.dart';
import 'package:riverbank_pretotype_mobile/login/model/user.dart';
import 'package:riverbank_pretotype_mobile/login/repository/user_repository.dart';

import 'model/balance.dart';

class BalancePage extends StatefulWidget {
  const BalancePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BalancePageState();
  }
}

class _BalancePageState extends State<BalancePage> with WidgetsBindingObserver {

  final UserRepository _userRepository = UserRepository();
  final BalanceRepository _balanceRepository = BalanceRepository();
  final _balanceService = BalanceService();

  Future<Balance> _getBalance() async {
    final balance = await _balanceService.get(_userRepository.getId(), 'KRW');
    return balance;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('didChange');
    if (state == AppLifecycleState.resumed) {
      print('resume');
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = _userRepository.getSavedUser()!;
    _getBalance();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: riverbankPurple,
        title: const Text('Riverbank', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              context.push("/translation");
            },
            icon: const Icon(Icons.g_translate_outlined, color: Colors.white))
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.only(left: 24, top: 20, bottom: 20),
            decoration: const BoxDecoration(
              color: riverbankPurple
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                user.profileImageUrl != null ?
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(user.profileImageUrl!, width: 50, height: 50, errorBuilder: (context, object, _) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset('asset/image/sample_avatar.png', width: 50, height: 50,),
                      );
                    },)
                  ) :
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset('asset/image/sample_avatar.png', width: 50, height: 50,),
                  ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hi, ${user.name}!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                    const Text('Get cheapest foreign currency!', style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white))
                  ],
                )
              ],
            ),
          ),
          Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 60),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))
              ),
              margin: const EdgeInsets.only(top: 85),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Your balance', style: TextStyle(color: Color(0xff222222), fontSize: 20, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 20),
                      Container(
                          width: double.infinity,
                          height: 220,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: const Color(0xFFFFB242),
                            border: Border.all(color: Colors.black, width: 2)
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              children: [
                                Positioned(
                                    left: -130,
                                    top: -25,
                                    child: Container(
                                      width: 350,
                                      height: 350,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF292949),
                                        borderRadius: BorderRadius.all(Radius.circular(360)),
                                      ),
                                    )
                                ),
                                Positioned(
                                    left: 224,
                                    top: -60,
                                    child: Container(
                                      width: 190,
                                      height: 190,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEA403F),
                                        borderRadius: BorderRadius.all(Radius.circular(360)),
                                      ),
                                    )
                                ),
                                Container(
                                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Obx(() => Text(toCurrencyForm(_balanceRepository.balance.value.amount.toString()), style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold))),
                                                const Text(' KRW', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                                              ],
                                            ),
                                            // const Text('100,000 KRW', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                                            Image.asset('asset/image/logo_white.png', width: 32,),
                                          ],
                                        ),
                                      ],
                                    )
                                )
                              ],
                            )
                          )
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff3629B7),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: CupertinoButton(
                              onPressed: () {
                                context.push("/withdrawal");
                              },
                              child: const Center(
                                  child: Text('Withdraw', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                              )
                          )
                      ),
                      SizedBox(height: 8,),
                      Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff3629B7),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: CupertinoButton(
                              onPressed: () {
                                context.push("/exchange");
                              },
                              child: const Center(
                                  child: Text('Go To Exchange', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                              )
                          )
                      )
                    ],
                  )
                ],
              )
          )
        ],
      )
    );
  }

}