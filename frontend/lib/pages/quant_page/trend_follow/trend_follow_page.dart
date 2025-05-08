import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot_flutter/pages/loading_pages/skeleton_list_loading.dart';
import 'package:quant_bot_flutter/core/colors.dart';
import 'package:quant_bot_flutter/pages/stocks_page/stocks_page_search_bar.dart';
import 'package:quant_bot_flutter/providers/step_form_provider.dart';
import 'package:quant_bot_flutter/providers/stocks_provider.dart';

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
        title: const Text('주식 선택',
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
                                ref
                                    .read(stepFormProvider.notifier)
                                    .setTicker(stock.ticker);
                                context.push(
                                    '/quant-form/quant/trend-follow/${stock.ticker}');
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
}
