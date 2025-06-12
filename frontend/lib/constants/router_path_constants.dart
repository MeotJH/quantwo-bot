import 'package:quant_bot_flutter/constants/router_routes.dart';

class RouterPath {
  static const String initialLocation = '/';
  static const String stockListPath = '/main';
  static const String trendFollow =
      '/quants/trend-follow/:assetType/:ticker'; // trendFollow
  static const String profilePath = '/profile';
  static const String loginPath = '/login';
  static const String signUpPath = '/sign-up';
  static const String signUpCompletePath = '/sign-up-complete';
  static const String quantPath = '/quant-form';
  static const String strategySelectPath = '/quant-form/strategy';
  static const String dualMomentumInternationalPath =
      '/quant-form/quant/dual-momentum/international';
  static const String toolsPath = toolsSelectPath;
}
