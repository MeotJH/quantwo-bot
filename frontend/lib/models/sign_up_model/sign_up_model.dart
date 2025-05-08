import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_model.freezed.dart';
part 'sign_up_model.g.dart';

@freezed
class SignUpModel with _$SignUpModel {
  @JsonSerializable(
    includeIfNull: false,
    explicitToJson: true,
  )
  factory SignUpModel({
    @Default('') String userName,
    @Default('') String email,
    @Default('') String password,
    @Default('') String mobile,
    @Default(true) bool isEmailValid,
    @Default(true) bool isPasswordValid,
    @Default(true) bool isPasswordMatched,
    String? appToken,
  }) = _SignUpModel;
  factory SignUpModel.fromJson({required Map<String, Object?> json}) =>
      _$SignUpModelFromJson(json);
}
