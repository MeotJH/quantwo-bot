// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StockModelImpl _$$StockModelImplFromJson(Map<String, dynamic> json) =>
    _$StockModelImpl(
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
    );

Map<String, dynamic> _$$StockModelImplToJson(_$StockModelImpl instance) =>
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
    };
