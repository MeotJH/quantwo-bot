import 'package:freezed_annotation/freezed_annotation.dart';

part 'dual_momentum_international_model.freezed.dart';
part 'dual_momentum_international_model.g.dart';

@freezed
class DualMomentumInternationalModel with _$DualMomentumInternationalModel {
  const factory DualMomentumInternationalModel({
    required List<TradeRecord> data,
    required Summary summary,
  }) = _DualMomentumInternationalModel;

  factory DualMomentumInternationalModel.fromJson(Map<String, dynamic> json) =>
      _$DualMomentumInternationalModelFromJson(json);
}

@freezed
class TradeRecord with _$TradeRecord {
  const factory TradeRecord({
    @JsonKey(name: 'date') required DateTime date,
    @JsonKey(name: 'best_etf') required String bestEtf,
    @JsonKey(name: '6m_return') double? sixMonthReturn,
    @JsonKey(name: 'capital') required double capital,
    @JsonKey(name: 'cash_hold') required double cashHold,
    @JsonKey(name: 'ewy_hold') required double ewyHold,
  }) = _TradeRecord;

  factory TradeRecord.fromJson(Map<String, dynamic> json) =>
      _$TradeRecordFromJson(json);
}

@freezed
class Summary with _$Summary {
  const factory Summary({
    @JsonKey(name: 'initial_capital') required double initialCapital,
    @JsonKey(name: 'final_capital') required double finalCapital,
    @JsonKey(name: 'total_return') required double totalReturn,
    @JsonKey(name: 'cash_hold_return') required double cashHoldReturn,
    @JsonKey(name: 'ewy_hold_return') required double ewyHoldReturn,
    @JsonKey(name: 'final_best_etf') required String finalBestEtf,
    @JsonKey(name: 'today_best_profit') required double todayBestProfit,
  }) = _Summary;

  factory Summary.fromJson(Map<String, dynamic> json) =>
      _$SummaryFromJson(json);
}
