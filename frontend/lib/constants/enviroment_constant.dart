import 'package:quant_bot_flutter/constants/api_constants.dart';

class Environment {
  static const _environment = String.fromEnvironment('ENVIRONMENT');
  static final env =
      (_environment == null || _environment.isEmpty) ? 'LOCAL' : _environment;
  static final serverUri = env == 'PROD' ? ApiUrl.prodUri : ApiUrl.webLocalUri;
}

// ignore: non_constant_identifier_names
