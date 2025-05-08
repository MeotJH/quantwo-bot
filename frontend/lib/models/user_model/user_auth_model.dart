import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_auth_model.freezed.dart';
part 'user_auth_model.g.dart';

@freezed
class UserAuthModel with _$UserAuthModel {
  const UserAuthModel._(); // ✅ private 생성자 추가

  @JsonSerializable(
    includeIfNull: false,
    explicitToJson: true,
  )
  factory UserAuthModel({
    @Default('') String email,
    @Default('') String password,
  }) = _UserAuthModel;

  factory UserAuthModel.fromJson(Map<String, dynamic> json) =>
      _$UserAuthModelFromJson(json); // ✅ positional parameter로 수정

  bool get isValid => email.isNotEmpty && password.isNotEmpty;
}
