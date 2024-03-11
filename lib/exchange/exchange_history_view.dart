import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:riverbank_pretotype_mobile/common/number_formatter.dart';
import 'package:riverbank_pretotype_mobile/exchange/service/exchange_history_service.dart';
import 'package:riverbank_pretotype_mobile/login/repository/user_repository.dart';

class ExchangeHistoryPage extends StatefulWidget {
  const ExchangeHistoryPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExchangeHistoryPageState();
  }

}

class _ExchangeHistoryPageState extends State<ExchangeHistoryPage> {
  final _historyService = ExchangeHistoryService();
  final _userService = UserRepository();

  String _toDateString(String date) {
    var dateTime = DateTime.parse(date);
    return DateFormat('yyyy-MM-dd kk:mm:ss').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    var userId = _userService.getSavedUser()?.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exchange History', style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: _historyService.getExchangeHistoriesById(userId!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: List.generate(snapshot.data?.length ?? 0, (index) {
                    var data = snapshot.data?[index];
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text("#", style: TextStyle(fontWeight: FontWeight.bold),),
                                        Text(data?.id.substring(0, 5) ?? ''),
                                      ],
                                    ),
                                    Text(_toDateString(data?.createdAt ?? '')),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: (data?.isFinalized ?? false) ? Colors.blueAccent : Colors.redAccent,
                                  ),
                                  child: Text((data?.isFinalized ?? false) ? "Completed" : "Pending", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),),
                                ),
                              ],
                            )
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Text(toCurrencyForm(data?.originalAmount.toString() ?? ''), style: TextStyle(fontSize: 18),),
                              const Text(" "),
                              Text(data?.originalCurrency ?? '', style: TextStyle(fontSize: 18)),
                              const Text(" => "),
                              Text(toCurrencyForm(data?.targetAmount.toString() ?? ''), style: TextStyle(fontSize: 18)),
                              const Text(" "),
                              Text(data?.targetCurrency ?? '', style: TextStyle(fontSize: 18)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text("Fee: ", style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(data?.fee.toString() ?? ''),
                              const Text(" "),
                              Text(data?.feeCurrency ?? ''),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Text("Applied rate: ", style: TextStyle(fontWeight: FontWeight.bold)),
                              Text("1 ${data?.targetCurrency} = ${data?.appliedExchangeRate.toString() ?? ''} ${data?.originalCurrency}"),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Text("Method: ", style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(data?.method ?? '')
                            ],
                          )
                        ],
                      )
                    );
                  }),
                );
              } else {
                return Container(
                  child: Text("loading..."),
                );
              }
            }
        )),
      );
  }

}