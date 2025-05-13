import 'package:flutter_dotenv/flutter_dotenv.dart';

final env = dotenv.env['ENVIROMENT'];
// ignore: non_constant_identifier_names
final BACKEND_WITH_ENVIROMENT = ({
      'LOCAL': dotenv.env['DEV_URL'],
      'PROD': dotenv.env['PROD_URL'],
    }[env] ??
    'http://localhost:8080/api/v1');
