// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dual_momentum_international_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DualMomentumInternationalModel _$DualMomentumInternationalModelFromJson(
    Map<String, dynamic> json) {
  return _DualMomentumInternationalModel.fromJson(json);
}

/// @nodoc
mixin _$DualMomentumInternationalModel {
  List<TradeRecord> get data => throw _privateConstructorUsedError;
  Summary get summary => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DualMomentumInternationalModelCopyWith<DualMomentumInternationalModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DualMomentumInternationalModelCopyWith<$Res> {
  factory $DualMomentumInternationalModelCopyWith(
          DualMomentumInternationalModel value,
          $Res Function(DualMomentumInternationalModel) then) =
      _$DualMomentumInternationalModelCopyWithImpl<$Res,
          DualMomentumInternationalModel>;
  @useResult
  $Res call({List<TradeRecord> data, Summary summary});

  $SummaryCopyWith<$Res> get summary;
}

/// @nodoc
class _$DualMomentumInternationalModelCopyWithImpl<$Res,
        $Val extends DualMomentumInternationalModel>
    implements $DualMomentumInternationalModelCopyWith<$Res> {
  _$DualMomentumInternationalModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? summary = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<TradeRecord>,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as Summary,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SummaryCopyWith<$Res> get summary {
    return $SummaryCopyWith<$Res>(_value.summary, (value) {
      return _then(_value.copyWith(summary: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DualMomentumInternationalModelImplCopyWith<$Res>
    implements $DualMomentumInternationalModelCopyWith<$Res> {
  factory _$$DualMomentumInternationalModelImplCopyWith(
          _$DualMomentumInternationalModelImpl value,
          $Res Function(_$DualMomentumInternationalModelImpl) then) =
      __$$DualMomentumInternationalModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<TradeRecord> data, Summary summary});

  @override
  $SummaryCopyWith<$Res> get summary;
}

/// @nodoc
class __$$DualMomentumInternationalModelImplCopyWithImpl<$Res>
    extends _$DualMomentumInternationalModelCopyWithImpl<$Res,
        _$DualMomentumInternationalModelImpl>
    implements _$$DualMomentumInternationalModelImplCopyWith<$Res> {
  __$$DualMomentumInternationalModelImplCopyWithImpl(
      _$DualMomentumInternationalModelImpl _value,
      $Res Function(_$DualMomentumInternationalModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? summary = null,
  }) {
    return _then(_$DualMomentumInternationalModelImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<TradeRecord>,
      summary: null == summary
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as Summary,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DualMomentumInternationalModelImpl
    implements _DualMomentumInternationalModel {
  const _$DualMomentumInternationalModelImpl(
      {required final List<TradeRecord> data, required this.summary})
      : _data = data;

  factory _$DualMomentumInternationalModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$DualMomentumInternationalModelImplFromJson(json);

  final List<TradeRecord> _data;
  @override
  List<TradeRecord> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final Summary summary;

  @override
  String toString() {
    return 'DualMomentumInternationalModel(data: $data, summary: $summary)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DualMomentumInternationalModelImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.summary, summary) || other.summary == summary));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_data), summary);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DualMomentumInternationalModelImplCopyWith<
          _$DualMomentumInternationalModelImpl>
      get copyWith => __$$DualMomentumInternationalModelImplCopyWithImpl<
          _$DualMomentumInternationalModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DualMomentumInternationalModelImplToJson(
      this,
    );
  }
}

abstract class _DualMomentumInternationalModel
    implements DualMomentumInternationalModel {
  const factory _DualMomentumInternationalModel(
      {required final List<TradeRecord> data,
      required final Summary summary}) = _$DualMomentumInternationalModelImpl;

  factory _DualMomentumInternationalModel.fromJson(Map<String, dynamic> json) =
      _$DualMomentumInternationalModelImpl.fromJson;

  @override
  List<TradeRecord> get data;
  @override
  Summary get summary;
  @override
  @JsonKey(ignore: true)
  _$$DualMomentumInternationalModelImplCopyWith<
          _$DualMomentumInternationalModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TradeRecord _$TradeRecordFromJson(Map<String, dynamic> json) {
  return _TradeRecord.fromJson(json);
}

/// @nodoc
mixin _$TradeRecord {
  @JsonKey(name: 'date')
  DateTime get date => throw _privateConstructorUsedError;
  @JsonKey(name: 'best_etf')
  String get bestEtf => throw _privateConstructorUsedError;
  @JsonKey(name: '6m_return')
  double? get sixMonthReturn => throw _privateConstructorUsedError;
  @JsonKey(name: 'capital')
  double get capital => throw _privateConstructorUsedError;
  @JsonKey(name: 'cash_hold')
  double get cashHold => throw _privateConstructorUsedError;
  @JsonKey(name: 'ewy_hold')
  double get ewyHold => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TradeRecordCopyWith<TradeRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TradeRecordCopyWith<$Res> {
  factory $TradeRecordCopyWith(
          TradeRecord value, $Res Function(TradeRecord) then) =
      _$TradeRecordCopyWithImpl<$Res, TradeRecord>;
  @useResult
  $Res call(
      {@JsonKey(name: 'date') DateTime date,
      @JsonKey(name: 'best_etf') String bestEtf,
      @JsonKey(name: '6m_return') double? sixMonthReturn,
      @JsonKey(name: 'capital') double capital,
      @JsonKey(name: 'cash_hold') double cashHold,
      @JsonKey(name: 'ewy_hold') double ewyHold});
}

/// @nodoc
class _$TradeRecordCopyWithImpl<$Res, $Val extends TradeRecord>
    implements $TradeRecordCopyWith<$Res> {
  _$TradeRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? bestEtf = null,
    Object? sixMonthReturn = freezed,
    Object? capital = null,
    Object? cashHold = null,
    Object? ewyHold = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      bestEtf: null == bestEtf
          ? _value.bestEtf
          : bestEtf // ignore: cast_nullable_to_non_nullable
              as String,
      sixMonthReturn: freezed == sixMonthReturn
          ? _value.sixMonthReturn
          : sixMonthReturn // ignore: cast_nullable_to_non_nullable
              as double?,
      capital: null == capital
          ? _value.capital
          : capital // ignore: cast_nullable_to_non_nullable
              as double,
      cashHold: null == cashHold
          ? _value.cashHold
          : cashHold // ignore: cast_nullable_to_non_nullable
              as double,
      ewyHold: null == ewyHold
          ? _value.ewyHold
          : ewyHold // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TradeRecordImplCopyWith<$Res>
    implements $TradeRecordCopyWith<$Res> {
  factory _$$TradeRecordImplCopyWith(
          _$TradeRecordImpl value, $Res Function(_$TradeRecordImpl) then) =
      __$$TradeRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'date') DateTime date,
      @JsonKey(name: 'best_etf') String bestEtf,
      @JsonKey(name: '6m_return') double? sixMonthReturn,
      @JsonKey(name: 'capital') double capital,
      @JsonKey(name: 'cash_hold') double cashHold,
      @JsonKey(name: 'ewy_hold') double ewyHold});
}

/// @nodoc
class __$$TradeRecordImplCopyWithImpl<$Res>
    extends _$TradeRecordCopyWithImpl<$Res, _$TradeRecordImpl>
    implements _$$TradeRecordImplCopyWith<$Res> {
  __$$TradeRecordImplCopyWithImpl(
      _$TradeRecordImpl _value, $Res Function(_$TradeRecordImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? bestEtf = null,
    Object? sixMonthReturn = freezed,
    Object? capital = null,
    Object? cashHold = null,
    Object? ewyHold = null,
  }) {
    return _then(_$TradeRecordImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      bestEtf: null == bestEtf
          ? _value.bestEtf
          : bestEtf // ignore: cast_nullable_to_non_nullable
              as String,
      sixMonthReturn: freezed == sixMonthReturn
          ? _value.sixMonthReturn
          : sixMonthReturn // ignore: cast_nullable_to_non_nullable
              as double?,
      capital: null == capital
          ? _value.capital
          : capital // ignore: cast_nullable_to_non_nullable
              as double,
      cashHold: null == cashHold
          ? _value.cashHold
          : cashHold // ignore: cast_nullable_to_non_nullable
              as double,
      ewyHold: null == ewyHold
          ? _value.ewyHold
          : ewyHold // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TradeRecordImpl implements _TradeRecord {
  const _$TradeRecordImpl(
      {@JsonKey(name: 'date') required this.date,
      @JsonKey(name: 'best_etf') required this.bestEtf,
      @JsonKey(name: '6m_return') this.sixMonthReturn,
      @JsonKey(name: 'capital') required this.capital,
      @JsonKey(name: 'cash_hold') required this.cashHold,
      @JsonKey(name: 'ewy_hold') required this.ewyHold});

  factory _$TradeRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$TradeRecordImplFromJson(json);

  @override
  @JsonKey(name: 'date')
  final DateTime date;
  @override
  @JsonKey(name: 'best_etf')
  final String bestEtf;
  @override
  @JsonKey(name: '6m_return')
  final double? sixMonthReturn;
  @override
  @JsonKey(name: 'capital')
  final double capital;
  @override
  @JsonKey(name: 'cash_hold')
  final double cashHold;
  @override
  @JsonKey(name: 'ewy_hold')
  final double ewyHold;

  @override
  String toString() {
    return 'TradeRecord(date: $date, bestEtf: $bestEtf, sixMonthReturn: $sixMonthReturn, capital: $capital, cashHold: $cashHold, ewyHold: $ewyHold)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TradeRecordImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.bestEtf, bestEtf) || other.bestEtf == bestEtf) &&
            (identical(other.sixMonthReturn, sixMonthReturn) ||
                other.sixMonthReturn == sixMonthReturn) &&
            (identical(other.capital, capital) || other.capital == capital) &&
            (identical(other.cashHold, cashHold) ||
                other.cashHold == cashHold) &&
            (identical(other.ewyHold, ewyHold) || other.ewyHold == ewyHold));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, date, bestEtf, sixMonthReturn, capital, cashHold, ewyHold);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TradeRecordImplCopyWith<_$TradeRecordImpl> get copyWith =>
      __$$TradeRecordImplCopyWithImpl<_$TradeRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TradeRecordImplToJson(
      this,
    );
  }
}

abstract class _TradeRecord implements TradeRecord {
  const factory _TradeRecord(
          {@JsonKey(name: 'date') required final DateTime date,
          @JsonKey(name: 'best_etf') required final String bestEtf,
          @JsonKey(name: '6m_return') final double? sixMonthReturn,
          @JsonKey(name: 'capital') required final double capital,
          @JsonKey(name: 'cash_hold') required final double cashHold,
          @JsonKey(name: 'ewy_hold') required final double ewyHold}) =
      _$TradeRecordImpl;

  factory _TradeRecord.fromJson(Map<String, dynamic> json) =
      _$TradeRecordImpl.fromJson;

  @override
  @JsonKey(name: 'date')
  DateTime get date;
  @override
  @JsonKey(name: 'best_etf')
  String get bestEtf;
  @override
  @JsonKey(name: '6m_return')
  double? get sixMonthReturn;
  @override
  @JsonKey(name: 'capital')
  double get capital;
  @override
  @JsonKey(name: 'cash_hold')
  double get cashHold;
  @override
  @JsonKey(name: 'ewy_hold')
  double get ewyHold;
  @override
  @JsonKey(ignore: true)
  _$$TradeRecordImplCopyWith<_$TradeRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Summary _$SummaryFromJson(Map<String, dynamic> json) {
  return _Summary.fromJson(json);
}

/// @nodoc
mixin _$Summary {
  @JsonKey(name: 'initial_capital')
  double get initialCapital => throw _privateConstructorUsedError;
  @JsonKey(name: 'final_capital')
  double get finalCapital => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_return')
  double get totalReturn => throw _privateConstructorUsedError;
  @JsonKey(name: 'cash_hold_return')
  double get cashHoldReturn => throw _privateConstructorUsedError;
  @JsonKey(name: 'ewy_hold_return')
  double get ewyHoldReturn => throw _privateConstructorUsedError;
  @JsonKey(name: 'final_best_etf')
  String get finalBestEtf => throw _privateConstructorUsedError;
  @JsonKey(name: 'today_best_profit')
  double get todayBestProfit => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SummaryCopyWith<Summary> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SummaryCopyWith<$Res> {
  factory $SummaryCopyWith(Summary value, $Res Function(Summary) then) =
      _$SummaryCopyWithImpl<$Res, Summary>;
  @useResult
  $Res call(
      {@JsonKey(name: 'initial_capital') double initialCapital,
      @JsonKey(name: 'final_capital') double finalCapital,
      @JsonKey(name: 'total_return') double totalReturn,
      @JsonKey(name: 'cash_hold_return') double cashHoldReturn,
      @JsonKey(name: 'ewy_hold_return') double ewyHoldReturn,
      @JsonKey(name: 'final_best_etf') String finalBestEtf,
      @JsonKey(name: 'today_best_profit') double todayBestProfit});
}

/// @nodoc
class _$SummaryCopyWithImpl<$Res, $Val extends Summary>
    implements $SummaryCopyWith<$Res> {
  _$SummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? initialCapital = null,
    Object? finalCapital = null,
    Object? totalReturn = null,
    Object? cashHoldReturn = null,
    Object? ewyHoldReturn = null,
    Object? finalBestEtf = null,
    Object? todayBestProfit = null,
  }) {
    return _then(_value.copyWith(
      initialCapital: null == initialCapital
          ? _value.initialCapital
          : initialCapital // ignore: cast_nullable_to_non_nullable
              as double,
      finalCapital: null == finalCapital
          ? _value.finalCapital
          : finalCapital // ignore: cast_nullable_to_non_nullable
              as double,
      totalReturn: null == totalReturn
          ? _value.totalReturn
          : totalReturn // ignore: cast_nullable_to_non_nullable
              as double,
      cashHoldReturn: null == cashHoldReturn
          ? _value.cashHoldReturn
          : cashHoldReturn // ignore: cast_nullable_to_non_nullable
              as double,
      ewyHoldReturn: null == ewyHoldReturn
          ? _value.ewyHoldReturn
          : ewyHoldReturn // ignore: cast_nullable_to_non_nullable
              as double,
      finalBestEtf: null == finalBestEtf
          ? _value.finalBestEtf
          : finalBestEtf // ignore: cast_nullable_to_non_nullable
              as String,
      todayBestProfit: null == todayBestProfit
          ? _value.todayBestProfit
          : todayBestProfit // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SummaryImplCopyWith<$Res> implements $SummaryCopyWith<$Res> {
  factory _$$SummaryImplCopyWith(
          _$SummaryImpl value, $Res Function(_$SummaryImpl) then) =
      __$$SummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'initial_capital') double initialCapital,
      @JsonKey(name: 'final_capital') double finalCapital,
      @JsonKey(name: 'total_return') double totalReturn,
      @JsonKey(name: 'cash_hold_return') double cashHoldReturn,
      @JsonKey(name: 'ewy_hold_return') double ewyHoldReturn,
      @JsonKey(name: 'final_best_etf') String finalBestEtf,
      @JsonKey(name: 'today_best_profit') double todayBestProfit});
}

/// @nodoc
class __$$SummaryImplCopyWithImpl<$Res>
    extends _$SummaryCopyWithImpl<$Res, _$SummaryImpl>
    implements _$$SummaryImplCopyWith<$Res> {
  __$$SummaryImplCopyWithImpl(
      _$SummaryImpl _value, $Res Function(_$SummaryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? initialCapital = null,
    Object? finalCapital = null,
    Object? totalReturn = null,
    Object? cashHoldReturn = null,
    Object? ewyHoldReturn = null,
    Object? finalBestEtf = null,
    Object? todayBestProfit = null,
  }) {
    return _then(_$SummaryImpl(
      initialCapital: null == initialCapital
          ? _value.initialCapital
          : initialCapital // ignore: cast_nullable_to_non_nullable
              as double,
      finalCapital: null == finalCapital
          ? _value.finalCapital
          : finalCapital // ignore: cast_nullable_to_non_nullable
              as double,
      totalReturn: null == totalReturn
          ? _value.totalReturn
          : totalReturn // ignore: cast_nullable_to_non_nullable
              as double,
      cashHoldReturn: null == cashHoldReturn
          ? _value.cashHoldReturn
          : cashHoldReturn // ignore: cast_nullable_to_non_nullable
              as double,
      ewyHoldReturn: null == ewyHoldReturn
          ? _value.ewyHoldReturn
          : ewyHoldReturn // ignore: cast_nullable_to_non_nullable
              as double,
      finalBestEtf: null == finalBestEtf
          ? _value.finalBestEtf
          : finalBestEtf // ignore: cast_nullable_to_non_nullable
              as String,
      todayBestProfit: null == todayBestProfit
          ? _value.todayBestProfit
          : todayBestProfit // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SummaryImpl implements _Summary {
  const _$SummaryImpl(
      {@JsonKey(name: 'initial_capital') required this.initialCapital,
      @JsonKey(name: 'final_capital') required this.finalCapital,
      @JsonKey(name: 'total_return') required this.totalReturn,
      @JsonKey(name: 'cash_hold_return') required this.cashHoldReturn,
      @JsonKey(name: 'ewy_hold_return') required this.ewyHoldReturn,
      @JsonKey(name: 'final_best_etf') required this.finalBestEtf,
      @JsonKey(name: 'today_best_profit') required this.todayBestProfit});

  factory _$SummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SummaryImplFromJson(json);

  @override
  @JsonKey(name: 'initial_capital')
  final double initialCapital;
  @override
  @JsonKey(name: 'final_capital')
  final double finalCapital;
  @override
  @JsonKey(name: 'total_return')
  final double totalReturn;
  @override
  @JsonKey(name: 'cash_hold_return')
  final double cashHoldReturn;
  @override
  @JsonKey(name: 'ewy_hold_return')
  final double ewyHoldReturn;
  @override
  @JsonKey(name: 'final_best_etf')
  final String finalBestEtf;
  @override
  @JsonKey(name: 'today_best_profit')
  final double todayBestProfit;

  @override
  String toString() {
    return 'Summary(initialCapital: $initialCapital, finalCapital: $finalCapital, totalReturn: $totalReturn, cashHoldReturn: $cashHoldReturn, ewyHoldReturn: $ewyHoldReturn, finalBestEtf: $finalBestEtf, todayBestProfit: $todayBestProfit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SummaryImpl &&
            (identical(other.initialCapital, initialCapital) ||
                other.initialCapital == initialCapital) &&
            (identical(other.finalCapital, finalCapital) ||
                other.finalCapital == finalCapital) &&
            (identical(other.totalReturn, totalReturn) ||
                other.totalReturn == totalReturn) &&
            (identical(other.cashHoldReturn, cashHoldReturn) ||
                other.cashHoldReturn == cashHoldReturn) &&
            (identical(other.ewyHoldReturn, ewyHoldReturn) ||
                other.ewyHoldReturn == ewyHoldReturn) &&
            (identical(other.finalBestEtf, finalBestEtf) ||
                other.finalBestEtf == finalBestEtf) &&
            (identical(other.todayBestProfit, todayBestProfit) ||
                other.todayBestProfit == todayBestProfit));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      initialCapital,
      finalCapital,
      totalReturn,
      cashHoldReturn,
      ewyHoldReturn,
      finalBestEtf,
      todayBestProfit);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SummaryImplCopyWith<_$SummaryImpl> get copyWith =>
      __$$SummaryImplCopyWithImpl<_$SummaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SummaryImplToJson(
      this,
    );
  }
}

abstract class _Summary implements Summary {
  const factory _Summary(
      {@JsonKey(name: 'initial_capital') required final double initialCapital,
      @JsonKey(name: 'final_capital') required final double finalCapital,
      @JsonKey(name: 'total_return') required final double totalReturn,
      @JsonKey(name: 'cash_hold_return') required final double cashHoldReturn,
      @JsonKey(name: 'ewy_hold_return') required final double ewyHoldReturn,
      @JsonKey(name: 'final_best_etf') required final String finalBestEtf,
      @JsonKey(name: 'today_best_profit')
      required final double todayBestProfit}) = _$SummaryImpl;

  factory _Summary.fromJson(Map<String, dynamic> json) = _$SummaryImpl.fromJson;

  @override
  @JsonKey(name: 'initial_capital')
  double get initialCapital;
  @override
  @JsonKey(name: 'final_capital')
  double get finalCapital;
  @override
  @JsonKey(name: 'total_return')
  double get totalReturn;
  @override
  @JsonKey(name: 'cash_hold_return')
  double get cashHoldReturn;
  @override
  @JsonKey(name: 'ewy_hold_return')
  double get ewyHoldReturn;
  @override
  @JsonKey(name: 'final_best_etf')
  String get finalBestEtf;
  @override
  @JsonKey(name: 'today_best_profit')
  double get todayBestProfit;
  @override
  @JsonKey(ignore: true)
  _$$SummaryImplCopyWith<_$SummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
