class ApiEndpoints {
  static const String signIn = '/users/sign-in';
  static const String findUserByAuth = '/users/';
  static const String oauthNaver = '/auth/oauth/naver';
}

class ApiStatus {
  static const int success = 200;
}

class ApiUrl {
  static const webLocalUri = 'http://localhost:8080/api/v1';
  static const appLocalUri = 'http://10.0.2.2:8080/api/v1';
  static const prodUri = 'https://d9f3eplsx2grg.cloudfront.net/api/v1';
}
