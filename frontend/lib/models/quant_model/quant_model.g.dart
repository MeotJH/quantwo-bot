// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuantModelImpl _$$QuantModelImplFromJson(Map<String, dynamic> json) =>
    _$QuantModelImpl(
      open: json['open'] as String? ?? '',
      high: json['high'] as String? ?? '',
      low: json['low'] as String? ?? '',
      close: json['close'] as String? ?? '',
      volume: json['volume'] as String? ?? '',
      dividends: json['dividends'] as String? ?? '',
      stockSplits: json['stock_splits'] as String? ?? '',
      trendFollow: json['trend_follow'] as String? ?? '',
      date: json['date'] as String? ?? '',
    );

Map<String, dynamic> _$$QuantModelImplToJson(_$QuantModelImpl instance) =>
    <String, dynamic>{
      'open': instance.open,
      'high': instance.high,
      'low': instance.low,
      'close': instance.close,
      'volume': instance.volume,
      'dividends': instance.dividends,
      'stock_splits': instance.stockSplits,
      'trend_follow': instance.trendFollow,
      'date': instance.date,
    };
