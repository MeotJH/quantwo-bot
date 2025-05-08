// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_auth_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserAuthResponseModelImpl _$$UserAuthResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserAuthResponseModelImpl(
      email: json['email'] as String,
      userName: json['userName'] as String,
      authorization: json['authorization'] as String,
    );

Map<String, dynamic> _$$UserAuthResponseModelImplToJson(
        _$UserAuthResponseModelImpl instance) =>
    <String, dynamic>{
      'email': instance.email,
      'userName': instance.userName,
      'authorization': instance.authorization,
    };
