import 'package:freezed_annotation/freezed_annotation.dart';

part 'trend_follow_list_model.freezed.dart';
part 'trend_follow_list_model.g.dart';

@freezed
class TrendFollowListModel with _$TrendFollowListModel {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
    includeIfNull: false,
    explicitToJson: true,
  )
  factory TrendFollowListModel({
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
    @Default('') String url,
    // Flask의 추가 필드
    @Default(0.0) double score,
    @Default('') String bucket,
    @Default(<String>[]) List<String> reasons,
  }) = _TrendFollowListModel;

  /// ✅ fromJson 수정: 서버에서 받은 Map을 Freezed 객체로 변환
  factory TrendFollowListModel.fromJson(Map<String, dynamic> json) =>
      _$TrendFollowListModelFromJson(json);

  /// ✅ 기존 커스텀 생성자 (optional): symbol → ticker 매핑 처리용
  factory TrendFollowListModel.fromStock(
      {required Map<String, dynamic> stock}) {
    return TrendFollowListModel(
      ticker: stock['symbol']?.toString() ?? stock['ticker']?.toString() ?? '',
      name: stock['name']?.toString() ?? '',
      lastsale: stock['lastsale']?.toString() ?? '',
      netchange: stock['netchange']?.toString() ?? '',
      pctchange: stock['pctchange']?.toString() ?? '',
      volume: stock['volume']?.toString() ?? '',
      marketCap: stock['market_cap']?.toString() ?? '',
      country: stock['country']?.toString() ?? '',
      ipoYear: stock['ipo_year']?.toString() ?? '',
      industry: stock['industry']?.toString() ?? '',
      check: stock['check']?.toString() ?? '',
      sector: stock['sector']?.toString() ?? '',
      url: stock['url']?.toString() ?? '',
      score: double.tryParse(stock['score']?.toString() ?? '') ?? 0.0,
      bucket: stock['bucket']?.toString() ?? '',
      reasons: (stock['reasons'] is List)
          ? List<String>.from(stock['reasons'])
          : <String>[],
    );
  }
}
