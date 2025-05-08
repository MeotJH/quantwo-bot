import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot_flutter/constants/router_routes.dart';
import 'package:quant_bot_flutter/core/colors.dart';
import 'package:quant_bot_flutter/pages/auth_pages/login_page.dart';
import 'package:quant_bot_flutter/pages/auth_pages/sign_up_complete_screen.dart';
import 'package:quant_bot_flutter/pages/auth_pages/sign_up_screen.dart';
import 'package:quant_bot_flutter/pages/quant_page/quant_page.dart';
import 'package:quant_bot_flutter/pages/quant_select_page/strategy_select_page.dart';
import 'package:quant_bot_flutter/pages/splash_pages/splash_page.dart';
import 'package:quant_bot_flutter/pages/stocks_page/stocks_page.dart';
import 'package:quant_bot_flutter/providers/auth_provider.dart';
import '../pages/profile_page/profile_page.dart';

// navigatorKey를 전역에서 사용하기 위해 선언
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final routerProvider =
    NotifierProvider<RouteNotifier, GoRouter>(RouteNotifier.new);

class RouteNotifier extends Notifier<GoRouter> {
  late final GoRouter _router;

  RouteNotifier() {
    _router = GoRouter(
      navigatorKey: navigatorKey,
      routes: [
        ShellRoute(
          builder: (context, state, child) {
            // 공통 Scaffold와 BottomNavigationBar 추가
            return ScaffoldWithNavBar(state: state, child: child);
          },
          routes: _buildRoutes(),
        ),
      ],
      initialLocation: _initialLocation,
    );
  }

  static const String _initialLocation = '/';
  static const String _stockListPath = '/main';
  static const String stockListPath = '/main';
  static const String _quantPath = '/quants/:quant/:ticker';
  static const String _profilePath = '/profile';
  static const String loginPath = '/login';
  static const String signUpPath = '/sign-up';
  static const String signUpCompletePath = '/sign-up-complete';
  static const String _strategySelectPath = '/quant-form/strategy';
  Widget _buildWithToken(
      BuildContext context, NotifierProviderRef<GoRouter> ref) {
    return FutureBuilder<String?>(
      future: ref.read(authStorageProvider.future),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            //여기
            GoRouter.of(context).go('/login');

            ref.read(bottomNavIndexProvider.notifier).state = 0;
          });
          return const SizedBox.shrink();
        }

        return ProfilePage();
      },
    );
  }

  List<GoRoute> _buildRoutes() => [
        GoRoute(
          path: _initialLocation,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: _stockListPath,
          builder: (context, state) => const StockListPage(),
        ),
        GoRoute(
          path: _quantPath,
          builder: (context, state) {
            final String ticker = state.pathParameters['ticker']!;
            final String quant = state.pathParameters['quant']!;
            return QuantPage(ticker: ticker, quant: quant);
          },
        ),
        GoRoute(
          path: _profilePath,
          builder: (context, state) {
            return _buildWithToken(context, ref);
          },
        ),
        GoRoute(
          path: loginPath,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: signUpPath,
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: signUpCompletePath,
          builder: (context, state) => const SignUpCompleteScreen(),
        ),
        GoRoute(
          path: _strategySelectPath,
          builder: (context, state) => const StrategySelectPage(),
        ),
        ...quantTypeRoutes,
      ];

  @override
  GoRouter build() => _router;
}

class ScaffoldWithNavBar extends ConsumerStatefulWidget {
  final Widget child;
  final GoRouterState state;

  const ScaffoldWithNavBar(
      {super.key, required this.child, required this.state});

  @override
  ConsumerState<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class _ScaffoldWithNavBarState extends ConsumerState<ScaffoldWithNavBar> {
  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(bottomNavIndexProvider);
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: isLoginPage()
          ? null // 로그인 페이지 일떄는 BottomNavigationBar를 숨김
          : BottomNavigationBar(
              currentIndex: selectedIndex,
              selectedItemColor: CustomColors.black,
              unselectedItemColor: CustomColors.gray40,
              onTap: (index) {
                ref.read(bottomNavIndexProvider.notifier).state = index;
                switch (index) {
                  case 0:
                    context.push(RouteNotifier._stockListPath);
                    break;
                  case 1:
                    context.push(RouteNotifier._strategySelectPath);
                    break;
                  case 2:
                    context.push(RouteNotifier._profilePath);
                    break;
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.show_chart_rounded),
                  label: 'Stocks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add_chart),
                  label: 'Quants',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
    );
  }

  bool isLoginPage() {
    final path = widget.state.fullPath;
    bool hideBottomNav = path == RouteNotifier.loginPath ||
        path == RouteNotifier.signUpPath ||
        path == RouteNotifier.signUpCompletePath ||
        path == RouteNotifier._initialLocation;
    return hideBottomNav;
  }
}

final routeProvider =
    NotifierProvider<RouteNotifier, GoRouter>(RouteNotifier.new);
