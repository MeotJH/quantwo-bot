import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:quant_bot_flutter/providers/stocks_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  double _opacity = 1.0;
  Timer? _timer; // 타이머 변수 추가

  void _startAnimation() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) return; // 위젯이 dispose되었으면 setState() 호출하지 않음
        setState(() {
          _opacity = _opacity == 1.0 ? 0.3 : 1.0;
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _startAnimation();
    ref.read(stocksProvider.future);
    Future.delayed(
      const Duration(seconds: 1),
      () {
        if (mounted) {
          context.push('/main');
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // dispose에서 타이머 정리
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(seconds: 1),
          opacity: _opacity,
          child: Image.asset(
            'assets/images/quant_bot.png',
          ),
        ),
      ),
    );
  }
}
