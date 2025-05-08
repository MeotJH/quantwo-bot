import 'package:freezed_annotation/freezed_annotation.dart';

part 'quant_model.freezed.dart';
part 'quant_model.g.dart';

///  {Date: 2023-10-02,
///  Open: 170.3483142712696,
/// High: 173.4126357064522,
/// Low: 170.05978216988254,
/// Close: 172.8654327392578,
///  Volume: 52164500,
///  Dividends: 0.0,
/// Stock Splits: 0.0,
/// Trend_Follow: nan},
@freezed
class QuantModel with _$QuantModel {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
    includeIfNull: false,
    explicitToJson: true,
  )
  factory QuantModel({
    @Default('') String open,
    @Default('') String high,
    @Default('') String low,
    @Default('') String close,
    @Default('') String volume,
    @Default('') String dividends,
    @Default('') String stockSplits,
    @Default('') String trendFollow,
    @Default('') String date,
  }) = _QuantModel;
  factory QuantModel.fromJson({required Map<String, dynamic> stock}) {
    return QuantModel(
      open: stock['Open'] as String,
      high: stock['High'] as String,
      low: stock['Low'] as String,
      close: stock['Close'] as String,
      volume: stock['Volume'] as String,
      dividends: stock['Dividends'] as String,
      stockSplits: stock['Stock Splits'] as String,
      trendFollow: stock['Trend_Follow'] as String,
      date: stock['Date'] as String,
    );
  }
}
