import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:riverbank_pretotype_mobile/balance/repository/balance_repository.dart';
import 'package:riverbank_pretotype_mobile/exchange/domain/exchanging.dart';
import 'package:riverbank_pretotype_mobile/exchange/service/exchange_history_service.dart';
import 'package:riverbank_pretotype_mobile/exchange/store/exchange_store.dart';

class InPersonBillingPage extends StatefulWidget {
  const InPersonBillingPage({super.key, this.restorationId});

  final String? restorationId;

  @override
  State<StatefulWidget> createState() {
    return _InPersonBillingPageState();
  }
}

class _InPersonBillingPageState extends State<InPersonBillingPage> with RestorationMixin {
  @override
  String? get restorationId => widget.restorationId;
  final _exchangeStore = ExchangeStore();
  bool _isSelectedOnce = false;
  final _snsTextEditingController = TextEditingController();
  final _spaceTextEditingController = TextEditingController();

  final RestorableDateTime _selectedDate = RestorableDateTime(DateTime.now());
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
  RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _selectedDate.value = newSelectedDate;
        _isSelectedOnce = true;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Selected: ${_selectedDate.value.day}/${_selectedDate.value.month}/${_selectedDate.value.year}'),
        ));
      });
    }
  }

  @pragma('vm:entry-point')
  static Route<DateTime> _datePickerRoute(
      BuildContext context,
      Object? arguments,
      ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: DateTime(2024),
          lastDate: DateTime(2100),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Text(AppLocalizations.of(context)!.directCurrencyExchange, style: const TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
              onPressed: () {
                context.push("/translation");
              },
              icon: const Icon(Icons.g_translate_outlined))
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraint) => ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraint.maxHeight
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Text('You can swap ${_exchangeStore.getOriginAmount()} ${_exchangeStore.getOriginCurrency()} to ${_exchangeStore.getTargetAmount() - _exchangeStore.getFee()} ${_exchangeStore.getTargetCurrency()} in person.'),
                    SizedBox(height: 20),
                    const Text('Where do you want to get currency?', style: TextStyle(fontWeight: FontWeight.bold,),),
                    TextField(
                      controller: _spaceTextEditingController,
                    ),
                    SizedBox(height: 10),
                    const Text('When do you want to get currency?', style: TextStyle(fontWeight: FontWeight.bold,),),
                    OutlinedButton(
                      onPressed: () {
                        _restorableDatePickerRouteFuture.present();
                      },
                      child: const Text('Select calendar')
                    ),
                    Text(_isSelectedOnce ? "${_selectedDate.value.year}-${_selectedDate.value.month}-${_selectedDate.value.day}" : ''),
                    SizedBox(height: 20),
                    Text('We will touch you to your messenger. Please enter your messenger'),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Instagram @riverbank'
                      ),
                      controller: _snsTextEditingController,
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff3629B7),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: CupertinoButton(
                    onPressed: () {
                      ExchangeStore().setIsFinalized(false);
                      ExchangeStore().setSns(_snsTextEditingController.value.text);
                      ExchangeStore().setMethod('in_person: ${_spaceTextEditingController.value.text}');
                      Exchanging().doExchange(
                          ExchangeHistoryService(),
                          BalanceRepository(),
                          ExchangeStore()).then((_) {
                        Fluttertoast.showToast(msg: 'Upload success!');
                      });
                      context.go('/balance');
                    },
                    child: Container(
                        child: Center(
                            child: Text(AppLocalizations.of(context)!.exchange, style: TextStyle(color: Colors.white, fontSize: 20))
                        )
                    ),
                  )
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}