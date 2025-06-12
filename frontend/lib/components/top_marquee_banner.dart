import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:quant_bot_flutter/common/colors.dart';
import 'package:quant_bot_flutter/constants/legal_notice.dart';

class TopMarqueeBanner extends StatefulWidget {
  const TopMarqueeBanner({super.key});

  @override
  State<TopMarqueeBanner> createState() => _TopMarqueeBannerState();
}

class _TopMarqueeBannerState extends State<TopMarqueeBanner> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // 마키 텍스트
          Expanded(
            child: SizedBox(
              height: 18,
              child: Marquee(
                text: legalNotice,
                style: TextStyle(
                  color: CustomColors.gray80.withOpacity(0.5),
                  fontSize: 14,
                ),
                blankSpace: 100,
                velocity: 20,
                pauseAfterRound: const Duration(seconds: 3),
              ),
            ),
          ),
          // 닫기 버튼
          IconButton(
            icon: Icon(Icons.close, color: CustomColors.black),
            onPressed: () {
              setState(() {
                _isVisible = false;
              });
            },
          )
        ],
      ),
    );
  }
}
