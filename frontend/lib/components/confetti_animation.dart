import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class ConfettiAnimation extends StatelessWidget {
  const ConfettiAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        color: Colors.transparent,
        child: const RiveAnimation.asset(
          'assets/animations/confetti.riv',
          animations: ['Confetti 1'],
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
