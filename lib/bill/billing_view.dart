import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riverbank_pretotype_mobile/common/fee_calculator.dart';
import 'package:riverbank_pretotype_mobile/common/number_formatter.dart';
import 'package:riverbank_pretotype_mobile/component/dashed_divider.dart';
import 'package:go_router/go_router.dart';
import 'package:riverbank_pretotype_mobile/exchange/repository/exchage_rate_repository.dart';
import 'package:riverbank_pretotype_mobile/exchange/store/exchange_store.dart';
import 'package:riverbank_pretotype_mobile/login/model/user.dart';
import 'package:riverbank_pretotype_mobile/login/repository/user_repository.dart';


class BillPage extends StatefulWidget {
  const BillPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return BillPageState();
  }
}

class BillPageState extends State<BillPage> {
  final UserRepository _userRepository = UserRepository();
  final ExchangeStore _store = ExchangeStore();

  String _calculateFee() {
    double a = (_store.getTargetAmount() * 0.01).floorToDouble();
    double b = (a / 100).floorToDouble() * 100;
    return b.toStringAsFixed(0);
  }

  String _calculateKrwAmountWithFloor() {
    double a = _store.getTargetAmount().floorToDouble();
    double b = (a / 100).floorToDouble() * 100;
    return b.toStringAsFixed(0);
  }

  Future<void> updateStore() async {
    _store.setTargetCurrency('KRW');
    _store.setTargetAmount(int.parse(_calculateKrwAmountWithFloor()));
    _store.setFee(int.parse(_calculateFee()));
    _store.setFeeCurrency('KRW');
    _store.setUserId(_userRepository.getId());
    var exchangeRate = await ExchangeRateRepository().getExchangeRate(_store.getOriginCurrency()!);
    double rate = 1 / exchangeRate.value;
    _store.setAppliedExchangeRate(double.parse(rate.toStringAsFixed(2)));
  }

  @override
  Widget build(BuildContext context) {
    User user = _userRepository.getSavedUser()!;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: const Text('Check the bill', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () {
              context.push("/translation");
            },
            icon: const Icon(Icons.g_translate_outlined))
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraint) => SingleChildScrollView(
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraint.maxHeight
                ),
                child: Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                        color: const Color(0xff3629B7).withOpacity(0.07),
                                        offset: const Offset(0, 4),
                                        blurRadius: 30
                                    )
                                  ]
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.only(bottom: 24),
                                    child: const Text('Bill', style: TextStyle(color: Color(0xff343434), fontSize: 16, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Name', style: TextStyle(color: Color(0xff979797), fontSize: 16, fontWeight: FontWeight.w600)),
                                      Text(user.name, style: const TextStyle(color: Color(0xff3629b7), fontSize: 16, fontWeight: FontWeight.w600))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Exchange Rate', style: TextStyle(color: Color(0xff979797), fontSize: 16, fontWeight: FontWeight.w600)),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text('1 ${_store.getOriginCurrency()}', style: const TextStyle(color: Color(0xff3629b7), fontSize: 16, fontWeight: FontWeight.w600)),
                                          Text('= ${toCurrencyForm(_store.getAppliedExchangeRate().toStringAsFixed(2))} ${_store.getTargetCurrency()}', style: const TextStyle(color: Color(0xff3629b7), fontSize: 16, fontWeight: FontWeight.w600))
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Exchange Amount', style: TextStyle(color: Color(0xff979797), fontSize: 18, fontWeight: FontWeight.w600)),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text("${toCurrencyFormFromInt(_store.getOriginAmount())} ${_store.getOriginCurrency()}", style: const TextStyle(color: Color(0xff3629b7), fontSize: 16, fontWeight: FontWeight.w600)),
                                          Text("= ${toCurrencyForm(_calculateKrwAmountWithFloor())} ${_store.getTargetCurrency()}", style: const TextStyle(color: Color(0xff3629b7), fontSize: 16, fontWeight: FontWeight.w600))
                                        ],
                                      )
                                    ],
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                    child: DashedDivider(height: 1, color: Color(0xffcbcbcb)),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Fee(1%)', style: TextStyle(color: Color(0xff979797), fontSize: 16, fontWeight: FontWeight.w600)),
                                      Text("KRW ${toCurrencyForm(_calculateFee())}", style: const TextStyle(color: Color(0xff3629b7), fontSize: 16, fontWeight: FontWeight.w600))
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                    child: DashedDivider(height: 1, color: Color(0xffcbcbcb)),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const Text('Total', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),
                                      Text("KRW ${toCurrencyFormFromInt(FeeCalculator.calculateWithFee(_store.getTargetAmount()).exchanged)}", style: TextStyle(color: Color(0xffff4267), fontSize: 24, fontWeight: FontWeight.w600))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
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
                                updateStore().then((_) => {
                                  context.push('/bill_method')
                                });
                              },
                              child: const Center(
                                  child: Text('Pay the bill', style: TextStyle(color: Colors.white, fontSize: 20))
                              )
                            )
                        )
                      ],
                    )
                )
            )
        ),
      ),
    );
  }

}