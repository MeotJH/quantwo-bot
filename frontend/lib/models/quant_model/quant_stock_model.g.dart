// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quant_stock_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuantStockModelImpl _$$QuantStockModelImplFromJson(
        Map<String, dynamic> json) =>
    _$QuantStockModelImpl(
      shortName: json['shortName'] as String?,
      currentPrice: (json['currentPrice'] as num?)?.toDouble(),
      previousClose: (json['previousClose'] as num?)?.toDouble(),
      open: (json['open'] as num?)?.toDouble(),
      volume: (json['volume'] as num?)?.toDouble(),
      dayHigh: (json['dayHigh'] as num?)?.toDouble(),
      dayLow: (json['dayLow'] as num?)?.toDouble(),
      trailingPE: (json['trailingPE'] as num?)?.toDouble(),
      fiftyTwoWeekHigh: (json['fiftyTwoWeekHigh'] as num?)?.toDouble(),
      fiftyTwoWeekLow: (json['fiftyTwoWeekLow'] as num?)?.toDouble(),
      trailingEps: (json['trailingEps'] as num?)?.toDouble(),
      enterpriseValue: (json['enterpriseValue'] as num?)?.toDouble(),
      ebitda: (json['ebitda'] as num?)?.toDouble(),
      lastCrossTrendFollow: (json['lastCrossTrendFollow'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$QuantStockModelImplToJson(
    _$QuantStockModelImpl instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('shortName', instance.shortName);
  writeNotNull('currentPrice', instance.currentPrice);
  writeNotNull('previousClose', instance.previousClose);
  writeNotNull('open', instance.open);
  writeNotNull('volume', instance.volume);
  writeNotNull('dayHigh', instance.dayHigh);
  writeNotNull('dayLow', instance.dayLow);
  writeNotNull('trailingPE', instance.trailingPE);
  writeNotNull('fiftyTwoWeekHigh', instance.fiftyTwoWeekHigh);
  writeNotNull('fiftyTwoWeekLow', instance.fiftyTwoWeekLow);
  writeNotNull('trailingEps', instance.trailingEps);
  writeNotNull('enterpriseValue', instance.enterpriseValue);
  writeNotNull('ebitda', instance.ebitda);
  writeNotNull('lastCrossTrendFollow', instance.lastCrossTrendFollow);
  return val;
}
