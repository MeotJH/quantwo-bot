import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_model.freezed.dart';
part 'stock_model.g.dart';

@freezed
class StockModel with _$StockModel {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
    includeIfNull: false,
    explicitToJson: true,
  )
  factory StockModel({
    @Default('') String ticker,
    @Default('') String name,
    @Default('') String lastsale,
    @Default('') String netchange,
    @Default('') String pctchange,
    @Default('') String volume,
    @Default('') String marketCap,
    @Default('') String country,
    @Default('') String ipoYear,
    @Default('') String industry,
    @Default('') String check,
    @Default('') String sector,
  }) = _StockModel;
  factory StockModel.fromJson({required Map<String, dynamic> stock}) {
    return StockModel(
      ticker: stock['symbol']?.toString() ?? '',
      name: stock['name']?.toString() ?? '',
      lastsale: stock['lastsale']?.toString() ?? '',
      netchange: stock['netchange']?.toString() ?? '',
      pctchange: stock['pctchange']?.toString() ?? '',
      volume: stock['volume']?.toString() ?? '',
      marketCap: stock['market_cap']?.toString() ?? '',
      country: stock['country']?.toString() ?? '',
      ipoYear: stock['ipo_year']?.toString() ?? '',
      industry: stock['industry']?.toString() ?? '',
      sector: stock['sector']?.toString() ?? '',
    );
  }
}
