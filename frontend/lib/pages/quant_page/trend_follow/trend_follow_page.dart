import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot/components/custom_button.dart';
import 'package:quant_bot/pages/loading_pages/skeleton_list_loading.dart';
import 'package:quant_bot/common/colors.dart';
import 'package:quant_bot/pages/stocks_page/stocks_page_search_bar.dart';
import 'package:quant_bot/providers/step_form_provider.dart';
import 'package:quant_bot/providers/stock_providers/stocks_provider.dart';

class TrendFollowPage extends ConsumerStatefulWidget {
  const TrendFollowPage({super.key});

  @override
  ConsumerState<TrendFollowPage> createState() => _TrendFollowPageState();
}

class _TrendFollowPageState extends ConsumerState<TrendFollowPage> {
  @override
  Widget build(BuildContext context) {
    final stocks = ref.watch(stocksProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('이 전략에 적용할 종목을 선택하세요',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
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
                child: stocks.when(
                    data: (stocks) {
                      return ListView.builder(
                        itemCount: stocks.length,
                        itemBuilder: (context, index) {
                          final stock = stocks[index];
                          return InkWell(
                            onTap: () async {
                              if (context.mounted) {
                                final encodedTicker =
                                    Uri.encodeComponent(stock.ticker);
                                ref
                                    .read(stepFormProvider.notifier)
                                    .setTicker(stock.ticker);
                                context.push(
                                    '/quant-form/quant/trend-follow/$encodedTicker');
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
                                            "${double.parse(stock.pctchange.replaceAll('%', '')).toStringAsFixed(2)}%", //상태
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '서버에 문제가 생겼습니다. \n 개발자 도비가 금방 조치할테니 조금만 기다려주세요.',
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  width: 200,
                                  child: CustomButton(
                                      onPressed: () async {
                                        await ref
                                            .read(stocksProvider.notifier)
                                            .refreshStocks();
                                      },
                                      textColor: CustomColors.white,
                                      backgroundColor:
                                          CustomColors.clearBlue120,
                                      text: '새로고침'),
                                )
                              ],
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
}
