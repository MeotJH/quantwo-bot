// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html; // 분기처리 해서 ignore

void removeQueryString() {
  final uri = Uri.base;
  final cleanedUri = uri.replace(queryParameters: {});
  html.window.history.replaceState(null, '', cleanedUri.toString());
}
