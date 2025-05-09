// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dual_momentum_international_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DualMomentumInternationalModelImpl
    _$$DualMomentumInternationalModelImplFromJson(Map<String, dynamic> json) =>
        _$DualMomentumInternationalModelImpl(
          data: (json['data'] as List<dynamic>)
              .map((e) => TradeRecord.fromJson(e as Map<String, dynamic>))
              .toList(),
          summary: Summary.fromJson(json['summary'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$$DualMomentumInternationalModelImplToJson(
        _$DualMomentumInternationalModelImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'summary': instance.summary,
    };

_$TradeRecordImpl _$$TradeRecordImplFromJson(Map<String, dynamic> json) =>
    _$TradeRecordImpl(
      date: DateTime.parse(json['date'] as String),
      bestEtf: json['best_etf'] as String,
      sixMonthReturn: (json['6m_return'] as num?)?.toDouble(),
      capital: (json['capital'] as num).toDouble(),
      cashHold: (json['cash_hold'] as num).toDouble(),
      ewyHold: (json['ewy_hold'] as num).toDouble(),
    );

Map<String, dynamic> _$$TradeRecordImplToJson(_$TradeRecordImpl instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'best_etf': instance.bestEtf,
      '6m_return': instance.sixMonthReturn,
      'capital': instance.capital,
      'cash_hold': instance.cashHold,
      'ewy_hold': instance.ewyHold,
    };

_$SummaryImpl _$$SummaryImplFromJson(Map<String, dynamic> json) =>
    _$SummaryImpl(
      initialCapital: (json['initial_capital'] as num).toDouble(),
      finalCapital: (json['final_capital'] as num).toDouble(),
      totalReturn: (json['total_return'] as num).toDouble(),
      cashHoldReturn: (json['cash_hold_return'] as num).toDouble(),
      ewyHoldReturn: (json['ewy_hold_return'] as num).toDouble(),
      finalBestEtf: json['final_best_etf'] as String,
      todayBestProfit: (json['today_best_profit'] as num).toDouble(),
    );

Map<String, dynamic> _$$SummaryImplToJson(_$SummaryImpl instance) =>
    <String, dynamic>{
      'initial_capital': instance.initialCapital,
      'final_capital': instance.finalCapital,
      'total_return': instance.totalReturn,
      'cash_hold_return': instance.cashHoldReturn,
      'ewy_hold_return': instance.ewyHoldReturn,
      'final_best_etf': instance.finalBestEtf,
      'today_best_profit': instance.todayBestProfit,
    };
