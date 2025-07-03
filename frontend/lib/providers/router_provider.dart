import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot/components/top_marquee_banner.dart';
import 'package:quant_bot/constants/nav_tab_enum.dart';
import 'package:quant_bot/constants/router_path_constants.dart';
import 'package:quant_bot/constants/router_routes.dart';
import 'package:quant_bot/common/colors.dart';
import 'package:quant_bot/models/trend_follow_model/trend_follow_args_model.dart';
import 'package:quant_bot/pages/auth_pages/login_page.dart';
import 'package:quant_bot/pages/auth_pages/sign_up_complete_screen.dart';
import 'package:quant_bot/pages/auth_pages/sign_up_screen.dart';
import 'package:quant_bot/pages/quant_page/quant_page.dart';
import 'package:quant_bot/pages/quant_select_page/strategy_select_page.dart';
import 'package:quant_bot/pages/splash_pages/splash_page.dart';
import 'package:quant_bot/pages/stocks_page/stocks_page.dart';
import 'package:quant_bot/providers/auth_provider.dart';
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
      initialLocation: RouterPath.initialLocation,
    );
  }

  // 프로필 페이지 갈때 토큰 검증 함수
  Widget _buildWithToken(
      BuildContext context, NotifierProviderRef<GoRouter> ref) {
    return FutureBuilder<String?>(
      future: ref.read(authStorageProvider.future),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        //에러있거나 데이터 없거나 널이면 로그인페이지로 간다.
        if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            GoRouter.of(context).go(RouterPath.loginPath);

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
          path: RouterPath.initialLocation,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: RouterPath.stockListPath,
          builder: (context, state) => const StockListPage(),
        ),
        GoRoute(
          path: RouterPath.trendFollow,
          builder: (context, state) {
            final String ticker = state.pathParameters['ticker']!;
            final String assetType = state.pathParameters['assetType']!;
            return QuantPage(
              tfArgs: TrendFollowArgs(
                ticker: ticker,
                assetType: assetType,
              ),
            );
          },
        ),
        GoRoute(
          path: RouterPath.profilePath,
          builder: (context, state) {
            return _buildWithToken(context, ref);
          },
        ),
        GoRoute(
          path: RouterPath.loginPath,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: RouterPath.signUpPath,
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: RouterPath.signUpCompletePath,
          builder: (context, state) => const SignUpCompleteScreen(),
        ),
        GoRoute(
          path: RouterPath.strategySelectPath,
          builder: (context, state) => const StrategySelectPage(),
        ),
        ...quantTypeRoutes,
        ...toolsRoutes,
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
    final path = widget.state.fullPath ?? RouterPath.stockListPath;
    final selectedIndex = ref.watch(bottomNavIndexProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentTab = NavTab.fromPath(path);
      if (ref.read(bottomNavIndexProvider) != currentTab.idx) {
        ref.read(bottomNavIndexProvider.notifier).state = currentTab.idx;
      }
    });

    return Scaffold(
      body: Column(
        children: [
          if (!isMinimalLayoutPage()) const TopMarqueeBanner(),
          Expanded(child: widget.child),
        ],
      ),
      bottomNavigationBar: isMinimalLayoutPage()
          ? null
          : BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: selectedIndex,
              selectedItemColor: CustomColors.black,
              unselectedItemColor: CustomColors.gray40,
              onTap: (index) {
                ref.read(bottomNavIndexProvider.notifier).state = index;
                final tab = NavTab.fromIndex(index);
                context.push(tab.path);
              },
              items: NavTab.values.map((tab) {
                return BottomNavigationBarItem(
                  icon: Icon(tab.icon),
                  label: tab.label,
                );
              }).toList(),
            ),
    );
  }

  bool isMinimalLayoutPage() {
    final path = widget.state.fullPath;
    return path == RouterPath.loginPath ||
        path == RouterPath.signUpPath ||
        path == RouterPath.signUpCompletePath ||
        path == RouterPath.initialLocation;
  }
}

final routeProvider =
    NotifierProvider<RouteNotifier, GoRouter>(RouteNotifier.new);
