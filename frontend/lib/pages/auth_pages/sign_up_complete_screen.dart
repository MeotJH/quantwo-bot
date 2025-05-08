import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot_flutter/components/confetti_animation.dart';
import 'package:quant_bot_flutter/components/custom_button.dart';
import 'package:quant_bot_flutter/core/colors.dart';
import 'package:flutter/foundation.dart';

class SignUpCompleteScreen extends StatelessWidget {
  const SignUpCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 실제 앱에서만 애니메이션 표시 여부 결정
    const showAnimation = !kDebugMode || kIsWeb;

    return Scaffold(
      body: const SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 100, color: Colors.green),
                  Text('회원가입이 완료되었습니다.', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
            // 실제 앱에서만 애니메이션 표시
            if (showAnimation)
              Positioned.fill(
                child: ConfettiAnimation(),
              ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomButton(
            onPressed: () {
              context.go('/login');
            },
            textColor: CustomColors.white,
            backgroundColor: CustomColors.black,
            text: '확인'),
      ),
    );
  }
}
