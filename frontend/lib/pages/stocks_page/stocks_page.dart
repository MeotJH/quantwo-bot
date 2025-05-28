import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot_flutter/common/custom_exception.dart';
import 'package:quant_bot_flutter/components/custom_dialog.dart';
import 'package:quant_bot_flutter/components/custom_toast.dart';
import 'package:quant_bot_flutter/common/colors.dart';
import 'package:quant_bot_flutter/pages/stocks_page/crypto_currency_list.dart';
import 'package:quant_bot_flutter/pages/stocks_page/stocks_page_search_bar.dart';
import 'package:quant_bot_flutter/pages/stocks_page/us_stock_list.dart';
import 'package:quant_bot_flutter/providers/auth_provider.dart';
import 'package:quant_bot_flutter/providers/dio_provider.dart';
import 'package:quant_bot_flutter/providers/router_provider.dart';
import 'package:quant_bot_flutter/providers/stock_providers/stock_tab_provider.dart';

class StockListPage extends ConsumerStatefulWidget {
  const StockListPage({super.key});

  @override
  ConsumerState<StockListPage> createState() => _StockListPageState();
}

//TODO 페이지 _tabController 외부로 Controller이 밖에 나와있어서 결합도 리팩토링
//TODO stock바뀔때 애니메이션 넣기
class _StockListPageState extends ConsumerState<StockListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final currentIndex = ref.read(tabIndexProvider); // 초기값
    _tabController =
        TabController(length: 2, vsync: this, initialIndex: currentIndex);

    _tabController.addListener(() {
      // index가 변경될 때 provider에 반영
      if (_tabController.indexIsChanging == false) {
        ref.read(tabIndexProvider.notifier).state = _tabController.index;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final stocks = ref.watch(stocksProvider);
    final authStorageProfider = ref.watch(authStorageProvider);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/quant_bot.png',
              height: 70,
            ),
            const Text(
              'Quantwo Bot',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          authStorageProfider.when(
              data: (data) {
                return data == null
                    ? IconButton(
                        icon: const Icon(Icons.login),
                        onPressed: () async {
                          context.go(RouteNotifier.loginPath);
                        },
                      )
                    : IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () async {
                          await showQuantBotDialog(
                            context: context,
                            title: '로그아웃',
                            content: '로그아웃 하시겠습니까?',
                            isAlert: false,
                            setPositiveAction: () async {
                              await ref
                                  .read(authStorageProvider.notifier)
                                  .logout();
                              if (mounted) context.go(RouteNotifier.loginPath);
                            },
                          );
                        },
                      );
              },
              error: (e, _) => const Text('세션 정보 가져오기 실패'),
              loading: () => const Center(child: CircularProgressIndicator())),
        ],
        bottom: TabBar(
          labelColor: CustomColors.gray80,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: CustomColors.clearBlue100,
          controller: _tabController,
          tabs: const [
            Tab(text: '미국주식'),
            Tab(text: '코인'),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        color: const Color(0xFFF0F0F0),
        child: Column(
          children: [
            const StocksPageSearchBar(),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  UsStockList(),
                  CryptoCurrencyList(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void tokenHandler({required Uri uri, required WidgetRef ref}) async {
    final token = uri.queryParameters['token'];

    if (token == null) {
      return;
    }

    try {
      ref.read(dioProvider.notifier).addAuth(token: token);
      await ref.read(authStorageProvider.notifier).saveToken(token: token);
      CustomToast.show(message: '로그인 완료!', isWarn: true);
    } on CustomException catch (e) {
      e.showToastMessage();
    }
  }
}
