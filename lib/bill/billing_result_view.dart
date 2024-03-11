import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverbank_pretotype_mobile/common/fee_calculator.dart';
import 'package:riverbank_pretotype_mobile/common/number_formatter.dart';
import 'package:riverbank_pretotype_mobile/exchange/store/exchange_store.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return ResultPageState();
  }

}

class ResultPageState extends State<ResultPage> {
  final ExchangeStore _exchangeStore = ExchangeStore();

  Future<void> uploadExchangeData() async {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Successfully exchanged!', style: TextStyle(fontWeight: FontWeight.bold),)
      ),
      body: LayoutBuilder(
        builder: (context, constraint) => ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraint.maxHeight
          ),
          child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('asset/image/exchange_success.png'),
                    const SizedBox(height: 45,),
                    const Text('Successfully Exchanged!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF3629B7)),),
                    const SizedBox(height: 10,),
                    const Text('You have successfully transferred', style: TextStyle(fontSize: 16)),
                    Text('${_exchangeStore.getTargetCurrency()!.toUpperCase()} ${toCurrencyFormFromInt(FeeCalculator.calculateWithFee(_exchangeStore.getTargetAmount()).exchanged)}', style: TextStyle(fontSize: 16, color: Color(0xFFFF4267), fontWeight: FontWeight.bold)),
                    const SizedBox(height: 32,),
                    Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: const Color(0xff3929b7),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: CupertinoButton(
                            onPressed: () {
                              context.go("/balance");
                            },
                            child: const Center(
                                child: Text('Confirm', style: TextStyle(color: Colors.white, fontSize: 20))
                            )
                        )
                    )
                  ],
                )
              )
          )),
      )
    );
  }

}