import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot_flutter/components/custom_password_field.dart';
import 'package:quant_bot_flutter/components/custom_toast.dart';
import 'package:quant_bot_flutter/common/colors.dart';
import 'package:quant_bot_flutter/providers/router_provider.dart';
import 'package:quant_bot_flutter/providers/sign_up_provider.dart';
import 'package:quant_bot_flutter/services/phone_formatter_service.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final signupFormNotifier = ref.watch(signUpFormProvider.notifier);
    final signupFormState = ref.watch(signUpFormProvider);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            context.go(RouteNotifier.stockListPath);
          },
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('이름 *',
                      style: TextStyle(
                        fontSize: 12,
                      )),
                  TextField(
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'EX) 김퀀트',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.gray40),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.black),
                      ),
                    ),
                    controller: signupFormNotifier.nameController,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // 이메일 주소 입력 필드
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('이메일 주소 *', style: TextStyle(fontSize: 12)),
                  TextField(
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: 'EX) quant-bot@mail.dot ',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.gray40),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.black),
                      ),
                      errorText: signupFormState.isEmailValid
                          ? null
                          : '이메일 형식이 올바르지 않습니다.',
                    ),
                    controller: signupFormNotifier.emailController,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // 비밀번호 필드
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '비밀번호 * ',
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  CustomPasswordTextField(
                    controller: signupFormNotifier.passwordController,
                    errorText: signupFormState.isPasswordValid
                        ? null
                        : '비밀번호는 영문,특수문자,숫자가 포함된 8자리 이상이어야 합니다.',
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('비밀번호 확인 *', style: TextStyle(fontSize: 12)),
                  CustomPasswordTextField(
                    controller: signupFormNotifier.passwordDuplicateController,
                    errorText: signupFormState.isPasswordMatched
                        ? null
                        : '비밀번호가 일치하지 않습니다.',
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 0,
        child: Center(
          child: ElevatedButton(
            onPressed: () async {
              try {
                final result = await ref.read(
                  signUpProvider(ref.watch(signUpFormProvider)).future,
                );

                if (context.mounted) {
                  Navigator.pop(context); // 로딩 닫기
                  context.go(RouteNotifier.signUpCompletePath);
                  //context.go('/');
                }
              } catch (e) {}
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.grey[300],
              backgroundColor: CustomColors.black,
              fixedSize: const Size(600, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('회원가입'),
          ),
        ),
      ),
    );
  }
}
