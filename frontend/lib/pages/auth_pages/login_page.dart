import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot_flutter/components/custom_password_field.dart';
import 'package:quant_bot_flutter/components/custom_toast.dart';
import 'package:quant_bot_flutter/core/colors.dart';
import 'package:quant_bot_flutter/models/user_model/user_auth_model.dart';
import 'package:quant_bot_flutter/providers/auth_provider.dart';
import 'package:quant_bot_flutter/providers/router_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(authFormProvider);
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    _buildLogoAndSlogan(),
                    const SizedBox(height: 40),
                    _buildEmailField(ref),
                    const SizedBox(height: 20),
                    _buildPasswordField(ref),
                    const SizedBox(height: 30),
                    _buildLoginButton(context, ref, model),
                    const SizedBox(height: 10),
                    _buildNaverLoginButton(),
                    const SizedBox(height: 20),
                    _buildBottomLinks(context),
                    const Spacer(),
                    //_buildAppleLoginButton(),
                    //const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoAndSlogan() {
    return Column(
      children: [
        Image.asset(
          'assets/images/quant_bot.png',
          height: 200,
        ),
        const Text(
          "I'm Quant Two Bot, your personal quant",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildEmailField(WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('E-mail', style: TextStyle(fontSize: 14)),
        TextField(
          decoration: InputDecoration(
            hintText: 'EX) quant-bot@mail.dot',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: CustomColors.gray40),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: CustomColors.black),
            ),
          ),
          controller: ref.watch(authFormProvider.notifier).emailController,
        ),
      ],
    );
  }

  Widget _buildPasswordField(WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Password', style: TextStyle(fontSize: 14)),
        CustomPasswordTextField(
          controller: ref.watch(authFormProvider.notifier).passwordController,
        ),
      ],
    );
  }

  Widget _buildLoginButton(
      BuildContext context, WidgetRef ref, UserAuthModel model) {
    return ElevatedButton(
      onPressed: model.isValid
          ? () async {
              await ref.read(authProvider(model).future);
              if (!context.mounted) return;
              context.go(RouteNotifier.stockListPath);
            }
          : null,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.grey[300],
        backgroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text('로그인'),
    );
  }

  Widget _buildNaverLoginButton() {
    return ElevatedButton(
      onPressed: null,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF03C75A),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text('네이버로 로그인'),
    );
  }

  Widget _buildBottomLinks(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: () {
            context.push(RouteNotifier.signUpPath);
          },
          child: const Text(
            '이메일 가입',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        const Text('|', style: TextStyle(color: Colors.grey)),
        TextButton(
          onPressed: () async {
            // WebPushService webPushService = WebPushService();
            // await webPushService.unsubscribeAllPush();
            // await webPushService.subscribeToPush();
            CustomToast.show(message: '해당 기능은 준비중입니다.', isWarn: true);
          },
          child: const Text(
            '이메일 찾기',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        const Text('|', style: TextStyle(color: Colors.grey)),
        TextButton(
          onPressed: () {
            CustomToast.show(message: '해당 기능은 준비중입니다.', isWarn: true);
          },
          child: const Text(
            '비밀번호 찾기',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildAppleLoginButton() {
    return OutlinedButton.icon(
      onPressed: null,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        side: const BorderSide(color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      icon: const Icon(Icons.apple, color: Colors.black),
      label: const Text(
        'Apple로 로그인',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
