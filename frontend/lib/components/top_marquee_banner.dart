import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:quant_bot_flutter/core/colors.dart';

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
              height: 20,
              child: Marquee(
                text: '모든 투자는 개인의 선택이며 투자의 책임은 투자자 본인에게 있습니다.',
                style: TextStyle(color: CustomColors.gray80, fontSize: 16),
                blankSpace: 60,
                velocity: 50,
                pauseAfterRound: const Duration(seconds: 1),
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
