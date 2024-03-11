import 'package:intl/intl.dart';

final formatCurrency = NumberFormat('###,###,###,###');

String toCurrencyForm(String amount) {
  if (amount.contains('.')) {
    var split = amount.split(".");
    return "${formatCurrency.format(int.parse(split[0]))}.${split[1]}";
  }
  return formatCurrency.format(int.parse(amount));
}

String toCurrencyFormFromInt(int amount) {
  return formatCurrency.format(amount);
}