import 'package:quant_bot/constants/api_constants.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Environment {
  static const _environment = String.fromEnvironment('ENVIRONMENT');
  static late final String env;
  static String get serverUri => _urlMap[env] ?? _urlMap['LOCAL_WEB']!;

  Environment() {
    setEnvironment(_environment);
  }

  static const Map<String, String> _urlMap = {
    'PROD': ApiUrl.prodUri,
    'LOCAL_WEB': ApiUrl.webLocalUri,
    'LOCAL_APP': ApiUrl.appLocalUri,
  };

  static void setEnvironment(String environment) {
    if (Environment._urlMap.containsKey(environment)) {
      Environment.env = environment;
    } else {
      Environment.env = kIsWeb ? 'LOCAL_WEB' : 'LOCAL_APP';
    }
  }
}

// ignore: non_constant_identifier_names
