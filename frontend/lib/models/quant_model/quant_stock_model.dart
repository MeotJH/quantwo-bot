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
    String? shortName,
    double? currentPrice,
    double? previousClose,
    double? open,
    double? volume,
    double? dayHigh,
    double? dayLow,
    double? trailingPE,
    double? fiftyTwoWeekHigh,
    double? fiftyTwoWeekLow,
    double? trailingEps,
    double? enterpriseValue,
    double? ebitda,
    double? lastCrossTrendFollow,
  }) = _QuantStockModel;

  factory QuantStockModel.fromJson(Map<String, dynamic> json) =>
      _$QuantStockModelFromJson(json);
}
