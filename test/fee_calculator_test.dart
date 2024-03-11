import 'package:flutter_test/flutter_test.dart';
import 'package:riverbank_pretotype_mobile/common/fee_calculator.dart';

void main() {
  test('calculating fee and exchanged amount test', () {
    int originAmount = 12345678;
    FeeAndExchanged result = FeeCalculator.calculateWithFee(originAmount);
    print(result.fee);
    print(result.exchanged);
  });
}