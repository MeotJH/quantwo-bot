// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SignUpModelImpl _$$SignUpModelImplFromJson(Map<String, dynamic> json) =>
    _$SignUpModelImpl(
      userName: json['userName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      mobile: json['mobile'] as String? ?? '',
      isEmailValid: json['isEmailValid'] as bool? ?? true,
      isPasswordValid: json['isPasswordValid'] as bool? ?? true,
      isPasswordMatched: json['isPasswordMatched'] as bool? ?? true,
      appToken: json['appToken'] as String?,
    );

Map<String, dynamic> _$$SignUpModelImplToJson(_$SignUpModelImpl instance) {
  final val = <String, dynamic>{
    'userName': instance.userName,
    'email': instance.email,
    'password': instance.password,
    'mobile': instance.mobile,
    'isEmailValid': instance.isEmailValid,
    'isPasswordValid': instance.isPasswordValid,
    'isPasswordMatched': instance.isPasswordMatched,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('appToken', instance.appToken);
  return val;
}
