// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quant_stock_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuantStockModelImpl _$$QuantStockModelImplFromJson(
        Map<String, dynamic> json) =>
    _$QuantStockModelImpl(
      shortName: json['shortName'] as String? ?? '',
      currentPrice: json['currentPrice'] as String? ?? '',
      previousClose: json['previousClose'] as String? ?? '',
      open: json['open'] as String? ?? '',
      volume: json['volume'] as String? ?? '',
      dayHigh: json['dayHigh'] as String? ?? '',
      dayLow: json['dayLow'] as String? ?? '',
      trailingPE: json['trailingPE'] as String? ?? '',
      fiftyTwoWeekHigh: json['fiftyTwoWeekHigh'] as String? ?? '',
      fiftyTwoWeekLow: json['fiftyTwoWeekLow'] as String? ?? '',
      trailingEps: json['trailingEps'] as String? ?? '',
      enterpriseValue: json['enterpriseValue'] as String? ?? '',
      ebitda: json['ebitda'] as String? ?? '',
      lastCrossTrendFollow: json['lastCrossTrendFollow'] as String? ?? '',
    );

Map<String, dynamic> _$$QuantStockModelImplToJson(
        _$QuantStockModelImpl instance) =>
    <String, dynamic>{
      'shortName': instance.shortName,
      'currentPrice': instance.currentPrice,
      'previousClose': instance.previousClose,
      'open': instance.open,
      'volume': instance.volume,
      'dayHigh': instance.dayHigh,
      'dayLow': instance.dayLow,
      'trailingPE': instance.trailingPE,
      'fiftyTwoWeekHigh': instance.fiftyTwoWeekHigh,
      'fiftyTwoWeekLow': instance.fiftyTwoWeekLow,
      'trailingEps': instance.trailingEps,
      'enterpriseValue': instance.enterpriseValue,
      'ebitda': instance.ebitda,
      'lastCrossTrendFollow': instance.lastCrossTrendFollow,
    };
