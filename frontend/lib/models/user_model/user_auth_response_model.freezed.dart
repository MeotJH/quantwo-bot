// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_auth_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserAuthResponseModel _$UserAuthResponseModelFromJson(
    Map<String, dynamic> json) {
  return _UserAuthResponseModel.fromJson(json);
}

/// @nodoc
mixin _$UserAuthResponseModel {
  String get email => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get authorization => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserAuthResponseModelCopyWith<UserAuthResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserAuthResponseModelCopyWith<$Res> {
  factory $UserAuthResponseModelCopyWith(UserAuthResponseModel value,
          $Res Function(UserAuthResponseModel) then) =
      _$UserAuthResponseModelCopyWithImpl<$Res, UserAuthResponseModel>;
  @useResult
  $Res call({String email, String userName, String authorization});
}

/// @nodoc
class _$UserAuthResponseModelCopyWithImpl<$Res,
        $Val extends UserAuthResponseModel>
    implements $UserAuthResponseModelCopyWith<$Res> {
  _$UserAuthResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? userName = null,
    Object? authorization = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      authorization: null == authorization
          ? _value.authorization
          : authorization // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserAuthResponseModelImplCopyWith<$Res>
    implements $UserAuthResponseModelCopyWith<$Res> {
  factory _$$UserAuthResponseModelImplCopyWith(
          _$UserAuthResponseModelImpl value,
          $Res Function(_$UserAuthResponseModelImpl) then) =
      __$$UserAuthResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String userName, String authorization});
}

/// @nodoc
class __$$UserAuthResponseModelImplCopyWithImpl<$Res>
    extends _$UserAuthResponseModelCopyWithImpl<$Res,
        _$UserAuthResponseModelImpl>
    implements _$$UserAuthResponseModelImplCopyWith<$Res> {
  __$$UserAuthResponseModelImplCopyWithImpl(_$UserAuthResponseModelImpl _value,
      $Res Function(_$UserAuthResponseModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? userName = null,
    Object? authorization = null,
  }) {
    return _then(_$UserAuthResponseModelImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      authorization: null == authorization
          ? _value.authorization
          : authorization // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class _$UserAuthResponseModelImpl implements _UserAuthResponseModel {
  _$UserAuthResponseModelImpl(
      {required this.email,
      required this.userName,
      required this.authorization});

  factory _$UserAuthResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserAuthResponseModelImplFromJson(json);

  @override
  final String email;
  @override
  final String userName;
  @override
  final String authorization;

  @override
  String toString() {
    return 'UserAuthResponseModel(email: $email, userName: $userName, authorization: $authorization)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserAuthResponseModelImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.authorization, authorization) ||
                other.authorization == authorization));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, email, userName, authorization);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserAuthResponseModelImplCopyWith<_$UserAuthResponseModelImpl>
      get copyWith => __$$UserAuthResponseModelImplCopyWithImpl<
          _$UserAuthResponseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserAuthResponseModelImplToJson(
      this,
    );
  }
}

abstract class _UserAuthResponseModel implements UserAuthResponseModel {
  factory _UserAuthResponseModel(
      {required final String email,
      required final String userName,
      required final String authorization}) = _$UserAuthResponseModelImpl;

  factory _UserAuthResponseModel.fromJson(Map<String, dynamic> json) =
      _$UserAuthResponseModelImpl.fromJson;

  @override
  String get email;
  @override
  String get userName;
  @override
  String get authorization;
  @override
  @JsonKey(ignore: true)
  _$$UserAuthResponseModelImplCopyWith<_$UserAuthResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
