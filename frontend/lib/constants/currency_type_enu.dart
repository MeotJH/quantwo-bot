import 'package:number_display/number_display.dart';
import 'package:quant_bot/widgets/create_display_korean.dart';

enum CurrencyType {
  USD(
    value: 'usd',
    displayFunc: createDisplay,
  ),
  KOR(
    value: 'kor',
    displayFunc: createDisplayKorean,
  );

  final String value;
  final Function displayFunc;

  const CurrencyType({
    required this.value,
    required this.displayFunc,
  });

  static CurrencyType fromValue({String value = 'usd'}) {
    return CurrencyType.values.firstWhere(
      (currency) => value.contains(currency.value),
      orElse: () => CurrencyType.USD,
    );
  }
}
