// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_auth_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserAuthModel _$UserAuthModelFromJson(Map<String, dynamic> json) {
  return _UserAuthModel.fromJson(json);
}

/// @nodoc
mixin _$UserAuthModel {
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserAuthModelCopyWith<UserAuthModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserAuthModelCopyWith<$Res> {
  factory $UserAuthModelCopyWith(
          UserAuthModel value, $Res Function(UserAuthModel) then) =
      _$UserAuthModelCopyWithImpl<$Res, UserAuthModel>;
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class _$UserAuthModelCopyWithImpl<$Res, $Val extends UserAuthModel>
    implements $UserAuthModelCopyWith<$Res> {
  _$UserAuthModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserAuthModelImplCopyWith<$Res>
    implements $UserAuthModelCopyWith<$Res> {
  factory _$$UserAuthModelImplCopyWith(
          _$UserAuthModelImpl value, $Res Function(_$UserAuthModelImpl) then) =
      __$$UserAuthModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String password});
}

/// @nodoc
class __$$UserAuthModelImplCopyWithImpl<$Res>
    extends _$UserAuthModelCopyWithImpl<$Res, _$UserAuthModelImpl>
    implements _$$UserAuthModelImplCopyWith<$Res> {
  __$$UserAuthModelImplCopyWithImpl(
      _$UserAuthModelImpl _value, $Res Function(_$UserAuthModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? password = null,
  }) {
    return _then(_$UserAuthModelImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class _$UserAuthModelImpl extends _UserAuthModel {
  _$UserAuthModelImpl({this.email = '', this.password = ''}) : super._();

  factory _$UserAuthModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserAuthModelImplFromJson(json);

  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String password;

  @override
  String toString() {
    return 'UserAuthModel(email: $email, password: $password)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserAuthModelImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, email, password);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserAuthModelImplCopyWith<_$UserAuthModelImpl> get copyWith =>
      __$$UserAuthModelImplCopyWithImpl<_$UserAuthModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserAuthModelImplToJson(
      this,
    );
  }
}

abstract class _UserAuthModel extends UserAuthModel {
  factory _UserAuthModel({final String email, final String password}) =
      _$UserAuthModelImpl;
  _UserAuthModel._() : super._();

  factory _UserAuthModel.fromJson(Map<String, dynamic> json) =
      _$UserAuthModelImpl.fromJson;

  @override
  String get email;
  @override
  String get password;
  @override
  @JsonKey(ignore: true)
  _$$UserAuthModelImplCopyWith<_$UserAuthModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
