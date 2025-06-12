import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:quant_bot_flutter/common/colors.dart';
import 'package:quant_bot_flutter/providers/router_provider.dart';

class CustomToast {
  static void show({
    required String message,
    bool isWarn = false,
    Duration duration = const Duration(seconds: 2),
  }) {
    final overlay = navigatorKey.currentState?.overlay;
    if (overlay != null) {
      final overlayEntry = OverlayEntry(
        builder: (context) => _CustomToastWidget(
          text: message,
          isWarn: isWarn,
        ),
      );

      overlay.insert(overlayEntry);

      Future.delayed(duration, () {
        overlayEntry.remove();
      });
    } else {
      log('No overlay found');
    }
  }
}

class _CustomToastWidget extends StatelessWidget {
  final String text;
  final bool isWarn;

  const _CustomToastWidget({
    required this.text,
    required this.isWarn,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50.0,
      left: 16.0,
      right: 16.0,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              isWarn
                  ? const Icon(Icons.error_outline, color: Colors.red)
                  : Icon(Icons.check_circle_outline,
                      color: CustomColors.clearBlue120),
              const SizedBox(width: 8.0),
              Flexible(
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.white, fontSize: 16.0),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
