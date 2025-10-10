// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trend_follow_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrendFollowListModelImpl _$$TrendFollowListModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TrendFollowListModelImpl(
      ticker: json['ticker'] as String? ?? '',
      name: json['name'] as String? ?? '',
      lastsale: json['lastsale'] as String? ?? '',
      netchange: json['netchange'] as String? ?? '',
      pctchange: json['pctchange'] as String? ?? '',
      volume: json['volume'] as String? ?? '',
      marketCap: json['market_cap'] as String? ?? '',
      country: json['country'] as String? ?? '',
      ipoYear: json['ipo_year'] as String? ?? '',
      industry: json['industry'] as String? ?? '',
      check: json['check'] as String? ?? '',
      sector: json['sector'] as String? ?? '',
      url: json['url'] as String? ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      bucket: json['bucket'] as String? ?? '',
      reasons: (json['reasons'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$$TrendFollowListModelImplToJson(
        _$TrendFollowListModelImpl instance) =>
    <String, dynamic>{
      'ticker': instance.ticker,
      'name': instance.name,
      'lastsale': instance.lastsale,
      'netchange': instance.netchange,
      'pctchange': instance.pctchange,
      'volume': instance.volume,
      'market_cap': instance.marketCap,
      'country': instance.country,
      'ipo_year': instance.ipoYear,
      'industry': instance.industry,
      'check': instance.check,
      'sector': instance.sector,
      'url': instance.url,
      'score': instance.score,
      'bucket': instance.bucket,
      'reasons': instance.reasons,
    };
