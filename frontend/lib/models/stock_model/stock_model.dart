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
      ticker: stock['symbol'] as String,
      name: stock['name'] as String,
      lastsale: stock['lastsale'] as String,
      netchange: stock['netchange'] as String,
      pctchange: stock['pctchange'] as String,
      volume: stock['volume'] as String,
      marketCap: stock['market_cap'] as String,
      country: stock['country'] as String,
      ipoYear: stock['ipo_year'] as String,
      industry: stock['industry'] as String,
      sector: stock['sector'] as String,
    );
  }
}
