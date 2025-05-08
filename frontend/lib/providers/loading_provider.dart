import "package:flutter_riverpod/flutter_riverpod.dart";

class LoadingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void startLoading() => state = true;
  void stopLoading() => state = false;

  Future<void> runWithLoading(Future<void> Function() asyncFunction) async {
    startLoading();
    try {
      await asyncFunction();
    } catch (e) {
      rethrow;
    } finally {
      stopLoading();
    }
  }
}

final loadingProvider = NotifierProvider<LoadingNotifier, bool>(() {
  return LoadingNotifier();
});
