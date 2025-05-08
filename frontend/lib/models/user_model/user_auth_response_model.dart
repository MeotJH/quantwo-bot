import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_auth_response_model.freezed.dart';
part 'user_auth_response_model.g.dart';

@freezed
class UserAuthResponseModel with _$UserAuthResponseModel {
  @JsonSerializable(
    includeIfNull: false,
    explicitToJson: true,
  )
  factory UserAuthResponseModel({
    required String email,
    required String userName,
    required String authorization,
  }) = _UserAuthResponseModel;

  factory UserAuthResponseModel.fromJson(Map<String, Object?> json) => _$UserAuthResponseModelFromJson(json);
}
