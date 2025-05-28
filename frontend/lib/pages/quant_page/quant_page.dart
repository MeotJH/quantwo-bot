import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot_flutter/components/line_chart.dart';
import 'package:quant_bot_flutter/common/colors.dart';
import 'package:quant_bot_flutter/models/quant_model/quant_stock_model.dart';
import 'package:quant_bot_flutter/models/trend_follow_model/trend_follow_args_model.dart';
import 'package:quant_bot_flutter/pages/loading_pages/skeleton_detail_page_loading.dart';
import 'package:quant_bot_flutter/pages/quant_page/quant_page_table.dart';
import 'package:quant_bot_flutter/providers/quant_provider.dart';

class QuantPage extends ConsumerStatefulWidget {
  final TrendFollowArgs tfArgs;

  const QuantPage({super.key, required this.tfArgs});

  @override
  ConsumerState<QuantPage> createState() => _QuantPageState();
}

class _QuantPageState extends ConsumerState<QuantPage> {
  @override
  Widget build(BuildContext context) {
    final trendFollow = ref.watch(
      trendFollowProvider(
        TrendFollowArgs(
            ticker: widget.tfArgs.ticker, assetType: widget.tfArgs.assetType),
      ),
    );
    final ticker = widget.tfArgs.ticker;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '주식 정보',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: trendFollow.when(
                  data: (data) {
                    final recentOne = data.recentStockOne;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recentOne.shortName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ticker,
                          style: TextStyle(
                            fontSize: 16,
                            color: CustomColors.gray50,
                          ),
                        ),
                        Text(
                          '\$${recentOne.currentPrice}',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _calNetChange(recentOne),
                          style: TextStyle(
                            fontSize: 12,
                            color: _getNetChangeColor(recentOne),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const SkeletonDetailPageLoading(
                    skeletonName: SkeletonDetailPageLoading.stockInfoSkeleton,
                  ),
                  error: (error, stack) {
                    return const Text('모..몬가 잘못되었음');
                  },
                )),
            SizedBox(
              height: 300,
              child: trendFollow.when(
                data: (data) {
                  return QuantLineChart(
                    firstChartData: data.firstLineChart,
                    secondChartData: data.secondLineChart,
                  );
                },
                error: (error, stack) {
                  return Text('Error: $error');
                },
                loading: () => const SkeletonDetailPageLoading(
                  skeletonName: SkeletonDetailPageLoading.stockChartSkeleton,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              alignment: Alignment.centerLeft,
              child: const Text(
                '주식 정보',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: trendFollow.when(
                data: (data) {
                  final recentStockData = data.recentStockOne;
                  return QuantPageTable(recentStockOne: recentStockData);
                },
                error: (error, stack) {
                  return Text('Error: $error');
                },
                loading: () => const SkeletonDetailPageLoading(
                  skeletonName:
                      SkeletonDetailPageLoading.trendFollowCardSkeleton,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _calNetChange(QuantStockModel recentStockOne) {
    final double netChange = double.parse(recentStockOne.currentPrice) -
        double.parse(recentStockOne.previousClose);

    final strNetChange = netChange.toStringAsFixed(2);
    final strNetChangePercent =
        (netChange / double.parse(recentStockOne.previousClose) * 100)
            .toStringAsFixed(2);
    return '\$$strNetChange ($strNetChangePercent%)';
  }

  Color _getNetChangeColor(QuantStockModel recentStockOne) {
    final double netChange = double.parse(recentStockOne.currentPrice) -
        double.parse(recentStockOne.previousClose);
    return netChange > 0 ? CustomColors.error : CustomColors.clearBlue100;
  }
}
