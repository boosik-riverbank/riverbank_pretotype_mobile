import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverbank_pretotype_mobile/balance/repository/balance_repository.dart';
import 'package:riverbank_pretotype_mobile/exchange/domain/exchanging.dart';
import 'package:riverbank_pretotype_mobile/exchange/service/exchange_history_service.dart';
import 'package:riverbank_pretotype_mobile/exchange/store/exchange_store.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BillMethodPage extends StatefulWidget {
  const BillMethodPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _BillMethodPageState();
  }

}

class BillMethod {
  BillMethod({required this.id, required this.img});

  String id;
  String img;

}

class _BillMethodPageState extends State<BillMethodPage> {
  List<BillMethod> methodList = [
    BillMethod(id: 'manual', img: ''),
    BillMethod(id: 'alipay', img: 'asset/image/bill_methods/alipay.png'),
    BillMethod(id: 'paypay', img: 'asset/image/bill_methods/paypay.png'),
    BillMethod(id: 'visa', img: 'asset/image/bill_methods/visa.png'),
    BillMethod(id: 'mastercard', img: 'asset/image/bill_methods/mastercard.png'),
    BillMethod(id: 'applepay', img: 'asset/image/bill_methods/applepay.png'),
    BillMethod(id: 'googlepay', img: 'asset/image/bill_methods/googlepay.png'),
    BillMethod(id: 'paypal', img: 'asset/image/bill_methods/paypal.png'),
    BillMethod(id: 'unionpay', img: 'asset/image/bill_methods/unionpay.png'),
    BillMethod(id: 'zalopay', img: 'asset/image/bill_methods/zalopay.png'),
    BillMethod(id: 'linepay', img: 'asset/image/bill_methods/linepay.png')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: const Text('Select Billing Method', style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            onPressed: () {
              context.push("/translation");
            },
            icon: Icon(Icons.g_translate_outlined))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          children: List.generate(methodList.length, (index) {
            if (methodList[index].id == 'manual') {
              return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xfff2f4f7), width: 1.5)
                  ),
                child: CupertinoButton(
                  onPressed: () {
                    context.push('/in_person');
                  },
                  child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('asset/image/in_person.png', width: 64, height: 64),
                          const SizedBox(height: 4),
                          Text(AppLocalizations.of(context)!.inPerson, style: TextStyle(color: Colors.black),)
                        ],
                      )
                  ),
                )
              );
            } else {
              return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xfff2f4f7), width: 1.5)
                  ),
                  child: CupertinoButton(
                    child: Center(
                        child: Image(image: AssetImage(methodList[index].img))
                    ),
                    onPressed: () {
                      // handle success
                      ExchangeStore().setIsFinalized(true);
                      Exchanging().doExchange(ExchangeHistoryService(), BalanceRepository(), ExchangeStore()).then((_) {
                        context.go('/result');
                      });
                    },
                  )
              );
            }
          }),
        )
      )
    );
  }

}