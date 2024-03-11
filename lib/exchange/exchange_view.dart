import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:riverbank_pretotype_mobile/component/dropdown.dart';
import 'package:go_router/go_router.dart';
import 'package:riverbank_pretotype_mobile/exchange/model/exchange_rate.dart';
import 'package:riverbank_pretotype_mobile/exchange/repository/exchage_rate_repository.dart';
import 'package:riverbank_pretotype_mobile/exchange/store/exchange_store.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExchangePage extends StatefulWidget {
  const ExchangePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return ExchangeState();
  }
}

class ExchangeState extends State<ExchangePage> {
  String currency = 'USD';
  int amount = 0;
  final ExchangeRateRepository _repository = ExchangeRateRepository();
  final TextEditingController _fromEditFieldController = TextEditingController(text: '0');
  var _canGoNext = false.obs;

  Future<String> getRate(String currency, int digit) async {
    ExchangeRate exchangeRate = await _repository.getExchangeRate(currency);
    return (1 / exchangeRate.value).toStringAsFixed(digit);
  }

  Future<String> getKrwAmount(String currency, int amount) async {
    print('getKrwAmount!!!, $currency $amount');
    ExchangeRate exchangeRate = await _repository.getExchangeRate(currency);
    double rate = 1 / exchangeRate.value;
    return (amount * rate).toStringAsFixed(0);
  }

  bool isAbleToGoNext() {
    return amount == 0;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Text(AppLocalizations.of(context)!.exchange, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () {
              context.push("/translation");
            },
            icon: const Icon(Icons.g_translate_outlined))
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 32, 0, 16),
                  height: 150,
                  child: SvgPicture.asset('asset/image/exchange.svg'),
                ),
                Container(
                    margin: const EdgeInsets.all(20),
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
                      children: [
                        // TODO : refactor with component
                        SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: const Text('From', style: TextStyle(color: Color(0xff979797), fontWeight: FontWeight.bold)),
                              ),
                              Row(
                                children: [
                                  Flexible(
                                      child: SizedBox(
                                        height: 60,
                                        child: TextField(
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(color: Color(0xffbfbfbf), width: 1),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(color: Color(0xffbfbfbf), width: 1),
                                              borderRadius: BorderRadius.circular(20),
                                            )
                                          ),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly
                                          ],
                                          controller: _fromEditFieldController,
                                          onChanged: (value) {
                                            setState(() {
                                              try {
                                                amount = int.parse(value);
                                                if (amount == 0 || value == '') {
                                                  _canGoNext.value = false;
                                                } else {
                                                  _canGoNext.value = true;
                                                }
                                              } catch (e) {
                                                amount = 0;
                                                _canGoNext.value = false;
                                              }
                                            });
                                          },
                                        )
                                      )
                                  ),
                                  const SizedBox(width: 8),
                                  Dropdown<String>(
                                    list: const ['USD', 'JPY', 'CNY'],
                                    onChanged: (String? value) {
                                      setState(() {
                                        currency = value!;
                                      });
                                    },
                                    value: currency,
                                  )
                                ],
                              ),
                              Center(
                                child: Container(
                                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                                  child: SvgPicture.asset('asset/image/exchange_arrow.svg'),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: const Text('To', style: TextStyle(color: Color(0xff979797), fontWeight: FontWeight.bold)),
                              ),
                              Row(
                                children: [
                                  Flexible(
                                      child: Container(
                                          padding: EdgeInsets.only(left: 10),
                                          width: double.infinity,
                                          height: 60,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: const Color(0xffbfbfbf)
                                              ),
                                              borderRadius: BorderRadius.circular(20)
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              FutureBuilder(
                                                future: getKrwAmount(currency, amount),
                                                builder: (context, snapshot) {
                                                  if (snapshot.hasData) {
                                                    return Text(snapshot.data!, style: const TextStyle(fontSize: 18));
                                                  } else if (snapshot.hasError) {
                                                    return Text("Error!");
                                                  } else {
                                                    return Text("loading...");
                                                  }
                                                })
                                            ],
                                          )
                                      )
                                  ),
                                  const SizedBox(width: 8),
                                  Dropdown<String>(
                                      list: const ['KRW'],
                                      onChanged: (String? value) {
                                      },
                                      value: 'KRW'
                                  )
                                ],
                              ),
                              Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(top: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Flexible(
                                          child: Text('Currency rate', style: TextStyle(fontSize: 12),)
                                      ),
                                      Flexible(
                                        child: FutureBuilder(
                                          future: getRate(currency, 2),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Text("1 $currency = ${snapshot.data} KRW", style: TextStyle(fontSize: 12),);
                                            }

                                            return const Text("Calculating...", style: TextStyle(fontSize: 12),);
                                          },
                                        )
                                      )
                                    ],
                                  )
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 40),
                                decoration: BoxDecoration(
                                  color: _canGoNext.value ? const Color(0xff3629B7) : Colors.black26,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: CupertinoButton(
                                  onPressed: _canGoNext.value ? () async {
                                    String krwAmount = await getKrwAmount(currency, amount);
                                    String exchangeRate = await getRate(currency, 2);
                                    ExchangeStore store = ExchangeStore();
                                    store.setOriginAmount(amount);
                                    store.setTargetAmount(int.parse(krwAmount));
                                    store.setOriginCurrency(currency.toUpperCase());
                                    store.setTargetCurrency('KRW');
                                    store.setAppliedExchangeRate(double.parse(exchangeRate));
                                    context.push("/receipt");
                                  } : null,
                                  child: Container(
                                      child: Center(
                                          child: Text(AppLocalizations.of(context)!.exchange, style: TextStyle(color: Colors.white, fontSize: 20))
                                      )
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                ),
              ],
            )
        )
      )
    );
  }
}