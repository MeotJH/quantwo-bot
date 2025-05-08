// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quant_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$QuantModel {
  String get open => throw _privateConstructorUsedError;
  String get high => throw _privateConstructorUsedError;
  String get low => throw _privateConstructorUsedError;
  String get close => throw _privateConstructorUsedError;
  String get volume => throw _privateConstructorUsedError;
  String get dividends => throw _privateConstructorUsedError;
  String get stockSplits => throw _privateConstructorUsedError;
  String get trendFollow => throw _privateConstructorUsedError;
  String get date => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $QuantModelCopyWith<QuantModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuantModelCopyWith<$Res> {
  factory $QuantModelCopyWith(
          QuantModel value, $Res Function(QuantModel) then) =
      _$QuantModelCopyWithImpl<$Res, QuantModel>;
  @useResult
  $Res call(
      {String open,
      String high,
      String low,
      String close,
      String volume,
      String dividends,
      String stockSplits,
      String trendFollow,
      String date});
}

/// @nodoc
class _$QuantModelCopyWithImpl<$Res, $Val extends QuantModel>
    implements $QuantModelCopyWith<$Res> {
  _$QuantModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? open = null,
    Object? high = null,
    Object? low = null,
    Object? close = null,
    Object? volume = null,
    Object? dividends = null,
    Object? stockSplits = null,
    Object? trendFollow = null,
    Object? date = null,
  }) {
    return _then(_value.copyWith(
      open: null == open
          ? _value.open
          : open // ignore: cast_nullable_to_non_nullable
              as String,
      high: null == high
          ? _value.high
          : high // ignore: cast_nullable_to_non_nullable
              as String,
      low: null == low
          ? _value.low
          : low // ignore: cast_nullable_to_non_nullable
              as String,
      close: null == close
          ? _value.close
          : close // ignore: cast_nullable_to_non_nullable
              as String,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as String,
      dividends: null == dividends
          ? _value.dividends
          : dividends // ignore: cast_nullable_to_non_nullable
              as String,
      stockSplits: null == stockSplits
          ? _value.stockSplits
          : stockSplits // ignore: cast_nullable_to_non_nullable
              as String,
      trendFollow: null == trendFollow
          ? _value.trendFollow
          : trendFollow // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuantModelImplCopyWith<$Res>
    implements $QuantModelCopyWith<$Res> {
  factory _$$QuantModelImplCopyWith(
          _$QuantModelImpl value, $Res Function(_$QuantModelImpl) then) =
      __$$QuantModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String open,
      String high,
      String low,
      String close,
      String volume,
      String dividends,
      String stockSplits,
      String trendFollow,
      String date});
}

/// @nodoc
class __$$QuantModelImplCopyWithImpl<$Res>
    extends _$QuantModelCopyWithImpl<$Res, _$QuantModelImpl>
    implements _$$QuantModelImplCopyWith<$Res> {
  __$$QuantModelImplCopyWithImpl(
      _$QuantModelImpl _value, $Res Function(_$QuantModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? open = null,
    Object? high = null,
    Object? low = null,
    Object? close = null,
    Object? volume = null,
    Object? dividends = null,
    Object? stockSplits = null,
    Object? trendFollow = null,
    Object? date = null,
  }) {
    return _then(_$QuantModelImpl(
      open: null == open
          ? _value.open
          : open // ignore: cast_nullable_to_non_nullable
              as String,
      high: null == high
          ? _value.high
          : high // ignore: cast_nullable_to_non_nullable
              as String,
      low: null == low
          ? _value.low
          : low // ignore: cast_nullable_to_non_nullable
              as String,
      close: null == close
          ? _value.close
          : close // ignore: cast_nullable_to_non_nullable
              as String,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as String,
      dividends: null == dividends
          ? _value.dividends
          : dividends // ignore: cast_nullable_to_non_nullable
              as String,
      stockSplits: null == stockSplits
          ? _value.stockSplits
          : stockSplits // ignore: cast_nullable_to_non_nullable
              as String,
      trendFollow: null == trendFollow
          ? _value.trendFollow
          : trendFollow // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(
    fieldRename: FieldRename.snake, includeIfNull: false, explicitToJson: true)
class _$QuantModelImpl implements _QuantModel {
  _$QuantModelImpl(
      {this.open = '',
      this.high = '',
      this.low = '',
      this.close = '',
      this.volume = '',
      this.dividends = '',
      this.stockSplits = '',
      this.trendFollow = '',
      this.date = ''});

  @override
  @JsonKey()
  final String open;
  @override
  @JsonKey()
  final String high;
  @override
  @JsonKey()
  final String low;
  @override
  @JsonKey()
  final String close;
  @override
  @JsonKey()
  final String volume;
  @override
  @JsonKey()
  final String dividends;
  @override
  @JsonKey()
  final String stockSplits;
  @override
  @JsonKey()
  final String trendFollow;
  @override
  @JsonKey()
  final String date;

  @override
  String toString() {
    return 'QuantModel(open: $open, high: $high, low: $low, close: $close, volume: $volume, dividends: $dividends, stockSplits: $stockSplits, trendFollow: $trendFollow, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuantModelImpl &&
            (identical(other.open, open) || other.open == open) &&
            (identical(other.high, high) || other.high == high) &&
            (identical(other.low, low) || other.low == low) &&
            (identical(other.close, close) || other.close == close) &&
            (identical(other.volume, volume) || other.volume == volume) &&
            (identical(other.dividends, dividends) ||
                other.dividends == dividends) &&
            (identical(other.stockSplits, stockSplits) ||
                other.stockSplits == stockSplits) &&
            (identical(other.trendFollow, trendFollow) ||
                other.trendFollow == trendFollow) &&
            (identical(other.date, date) || other.date == date));
  }

  @override
  int get hashCode => Object.hash(runtimeType, open, high, low, close, volume,
      dividends, stockSplits, trendFollow, date);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$QuantModelImplCopyWith<_$QuantModelImpl> get copyWith =>
      __$$QuantModelImplCopyWithImpl<_$QuantModelImpl>(this, _$identity);
}

abstract class _QuantModel implements QuantModel {
  factory _QuantModel(
      {final String open,
      final String high,
      final String low,
      final String close,
      final String volume,
      final String dividends,
      final String stockSplits,
      final String trendFollow,
      final String date}) = _$QuantModelImpl;

  @override
  String get open;
  @override
  String get high;
  @override
  String get low;
  @override
  String get close;
  @override
  String get volume;
  @override
  String get dividends;
  @override
  String get stockSplits;
  @override
  String get trendFollow;
  @override
  String get date;
  @override
  @JsonKey(ignore: true)
  _$$QuantModelImplCopyWith<_$QuantModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
