import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot_flutter/common/colors.dart';
import 'package:quant_bot_flutter/pages/loading_pages/skeleton_list_loading.dart';
import 'package:quant_bot_flutter/providers/stock_providers/stocks_provider.dart';

class UsStockList extends ConsumerWidget {
  const UsStockList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockData = ref.watch(stocksProvider);

    return stockData.when(
      data: (stocks) {
        return ListView.builder(
          itemCount: stocks.length,
          itemBuilder: (context, index) {
            final stock = stocks[index];
            return InkWell(
              onTap: () {
                if (context.mounted) {
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                      const SizedBox(height: 8),
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
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: Text(
                              '\$${double.parse(stock.lastsale.replaceAll('\$', '')).toStringAsFixed(2)}',
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
      ),
    );
  }
}
