import 'package:freezed_annotation/freezed_annotation.dart';

part 'quant_stock_model.freezed.dart';
part 'quant_stock_model.g.dart';

@freezed
class QuantStockModel with _$QuantStockModel {
  @JsonSerializable(
    fieldRename: FieldRename.none,
    includeIfNull: false,
    explicitToJson: true,
  )
  factory QuantStockModel({
    @Default('') String shortName,
    @Default('') String currentPrice,
    @Default('') String previousClose,
    @Default('') String open,
    @Default('') String volume,
    @Default('') String dayHigh,
    @Default('') String dayLow,
    @Default('') String trailingPE,
    @Default('') String fiftyTwoWeekHigh,
    @Default('') String fiftyTwoWeekLow,
    @Default('') String trailingEps,
    @Default('') String enterpriseValue,
    @Default('') String ebitda,
    @Default('') String lastCrossTrendFollow,
  }) = _QuantStockModel;
  factory QuantStockModel.fromJson({required Map<String, Object?> json}) =>
      _$QuantStockModelFromJson(json);
}
