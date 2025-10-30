import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot/constants/enviroment_constant.dart';
import 'package:quant_bot/providers/notification_bootstrap_provider.dart';
import 'package:quant_bot/providers/router_provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'dart:developer';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Environment();
  log('ENVIRONMENT: ${Environment.env}');
  setPathUrlStrategy();

  if (!kIsWeb) {
    await Firebase.initializeApp();
  }

  runApp(const ProviderScope(child: QuantBot()));
}

class QuantBot extends ConsumerStatefulWidget {
  const QuantBot({super.key});

  @override
  ConsumerState<QuantBot> createState() => _QuantBotState();
}

class _QuantBotState extends ConsumerState<QuantBot> {
  late final ProviderSubscription<AsyncValue<void>> _notificationSub;

  @override
  void initState() {
    super.initState();
    _notificationSub = ref.listenManual<AsyncValue<void>>(
      notificationBootstrapProvider,
      (prev, next) => next.when(
        data: (_) => log('알림 준비 완료'),
        error: (err, stack) => log('알림 초기화 실패: $err'),
        loading: () {},
      ),
      fireImmediately: true,
    );
  }

  @override
  void dispose() {
    _notificationSub.close();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Quant Bot',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white)
            .copyWith(background: Colors.white),
        dialogBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),
      routerConfig: ref.read(routeProvider),
    );
  }
}
