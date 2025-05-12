import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  @JsonSerializable(
    includeIfNull: false,
    explicitToJson: true,
  )
  factory UserModel(
      {required String email,
      required String userName,
      @Default(false) bool notification}) = _UserModel;

  factory UserModel.fromJson(Map<String, Object?> json) =>
      _$UserModelFromJson(json);
}
