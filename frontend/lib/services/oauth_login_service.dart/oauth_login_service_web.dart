import 'package:flutter/foundation.dart';
import 'package:quant_bot/constants/api_constants.dart';
import 'dart:html' as html;

import 'package:quant_bot/constants/enviroment_constant.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchNaverLogin() async {
  final currentLoca = html.window.location;
  final currentUri = '${currentLoca.protocol}//${currentLoca.host}';
  final oauthUrl =
      '${Environment.serverUri}${ApiEndpoints.oauthNaver}?redirect_uri=$currentUri';
  if (kIsWeb) {
    // ✅ 현재 탭에서 리다이렉트
    // ignore: avoid_web_libraries_in_flutter
    html.window.location.href = oauthUrl;
  } else {
    // ✅ 모바일/데스크탑은 외부 브라우저
    if (await canLaunchUrl(Uri.parse(oauthUrl))) {
      await launchUrl(Uri.parse(oauthUrl),
          mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $oauthUrl';
    }
  }
}

void launchNaverOAuthPopup() {
  html.window.open(
    Environment.serverUri! + ApiEndpoints.oauthNaver,
    'NaverLogin',
    'width=500,height=600',
  );
}
