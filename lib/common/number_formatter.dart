import 'package:intl/intl.dart';

final formatCurrency = NumberFormat('###,###,###,###');

String toCurrencyForm(String amount) {
  return formatCurrency.format(int.parse(amount));
}

String toCurrencyFormFromInt(int amount) {
  return formatCurrency.format(amount);
}