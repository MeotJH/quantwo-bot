import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot_flutter/common/custom_exception.dart';
import 'package:quant_bot_flutter/common/remove_query_string.dart';
import 'package:quant_bot_flutter/components/custom_dialog.dart';
import 'package:quant_bot_flutter/components/custom_toast.dart';
import 'package:quant_bot_flutter/pages/loading_pages/skeleton_list_loading.dart';
import 'package:quant_bot_flutter/common/colors.dart';
import 'package:quant_bot_flutter/pages/stocks_page/stocks_page_search_bar.dart';
import 'package:quant_bot_flutter/providers/auth_provider.dart';
import 'package:quant_bot_flutter/providers/dio_provider.dart';
import 'package:quant_bot_flutter/providers/router_provider.dart';
import 'package:quant_bot_flutter/providers/stocks_provider.dart';

class StockListPage extends ConsumerStatefulWidget {
  const StockListPage({super.key});

  @override
  ConsumerState<StockListPage> createState() => _StockListPageState();
}

class _StockListPageState extends ConsumerState<StockListPage> {
  bool _handledToken = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 1번만 실행하게 하기위해 작성한 로직
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_handledToken) {
        _handledToken = true;
        tokenHandler(uri: Uri.base, ref: ref);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final stocks = ref.watch(stocksProvider);
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
                child: stocks.when(
                    data: (stocks) {
                      return ListView.builder(
                        itemCount: stocks.length,
                        itemBuilder: (context, index) {
                          final stock = stocks[index];
                          return InkWell(
                            onTap: () async {
                              //final item = await CustomDialogDropDown.showCustomDialog(context);
                              if (mounted) {
                                context.push('/quants/TF/${stock.ticker}');
                              }
                            },
                            child: Container(
                              color: Colors.white,
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(vertical: 1),
                              height: 90,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          stock.ticker,
                                          style: const TextStyle(
                                            color: Color(0xFF222222),
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            stock.name,
                                            style: TextStyle(
                                              color: CustomColors.gray50,
                                              fontSize: 14,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          height: 32,
                                          width: 100,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: ShapeDecoration(
                                            color: stock.pctchange.contains('-')
                                                ? CustomColors.success
                                                : CustomColors.error,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                          ),
                                          child: Text(
                                            '\$${double.parse(stock.lastsale.replaceAll('\$', '')).toStringAsFixed(2)}', //상태
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    error: (error, stack) => Center(
                          child: Container(
                            alignment: Alignment.center,
                            color: CustomColors.white,
                            child: const Text(
                              '서버에 문제가 생겼습니다. \n 개발자 도비가 금방 조치할테니 조금만 기다려주세요.',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    loading: () => const Center(
                          child: SkeletonLoadingList(),
                        )),
              ),
            ],
          )),
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
      removeQueryString();
    } on CustomException catch (e) {
      e.showToastMessage();
    }
  }
}
