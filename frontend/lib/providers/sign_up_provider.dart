import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot/models/sign_up_model/sign_up_model.dart';
import 'package:quant_bot/providers/dio_provider.dart';
import 'package:quant_bot/services/sign_up_service.dart';

final signUpFormProvider =
    StateNotifierProvider.autoDispose<SignUpFormNotifier, SignUpModel>(
  (ref) => SignUpFormNotifier(),
);

class SignUpFormNotifier extends StateNotifier<SignUpModel> {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController passwordDuplicateController;
  final TextEditingController mobileController;

  bool isEmailValid = true;
  bool isPasswordValid = true;
  bool isPasswordMatched = true;

  SignUpFormNotifier()
      : nameController = TextEditingController(),
        emailController = TextEditingController(),
        passwordController = TextEditingController(),
        passwordDuplicateController = TextEditingController(),
        mobileController = TextEditingController(),
        isEmailValid = true,
        isPasswordValid = true,
        isPasswordMatched = true,
        super(
          SignUpModel(
            email: '',
            password: '',
            userName: '',
            mobile: '010-0000-0000',
            isEmailValid: true,
            isPasswordValid: true,
            isPasswordMatched: true,
          ),
        ) {
    emailController.addListener(() {
      state = state.copyWith(
        email: emailController.text,
        isEmailValid: SignUpService.validateEmail(
          emailController.text,
        ),
      );
    });
    passwordController.addListener(() {
      state = state.copyWith(
        password: passwordController.text,
        isPasswordValid:
            SignUpService.validatePassword(passwordController.text),
      );
    });
    passwordDuplicateController.addListener(() {
      state = state.copyWith(
        isPasswordMatched: SignUpService.validateMatchPassword(
          password: passwordController.text,
          passwordDuplicate: passwordDuplicateController.text,
        ),
      );
    });
    nameController.addListener(() {
      state = state.copyWith(userName: nameController.text);
    });
    mobileController.addListener(() {
      state = state.copyWith(mobile: mobileController.text);
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    mobileController.dispose();
    passwordDuplicateController.dispose();
    super.dispose();
  }
}

final signUpProvider = AsyncNotifierProvider.autoDispose
    .family<SignUpNotifier, void, SignUpModel>(SignUpNotifier.new);

class SignUpNotifier extends AutoDisposeFamilyAsyncNotifier<void, SignUpModel> {
  @override
  Future<void> build(SignUpModel model) async {
    final dio = ref.read(dioProvider);
    await SignUpService(model: model).signUp(dio: dio);
  }
}
