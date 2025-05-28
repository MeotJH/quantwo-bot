import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot_flutter/components/custom_button.dart';
import 'package:quant_bot_flutter/components/custom_dialog.dart';
import 'package:quant_bot_flutter/components/line_chart.dart';
import 'package:quant_bot_flutter/components/custom_toast.dart';
import 'package:quant_bot_flutter/constants/quant_type.dart';
import 'package:quant_bot_flutter/common/colors.dart';
import 'package:quant_bot_flutter/common/utils.dart';
import 'package:quant_bot_flutter/models/quant_model/quant_stock_model.dart';
import 'package:quant_bot_flutter/models/trend_follow_model/trend_follow_args_model.dart';
import 'package:quant_bot_flutter/pages/comm/quant_bot_detail_page_header.dart';
import 'package:quant_bot_flutter/pages/loading_pages/skeleton_detail_page_loading.dart';
import 'package:quant_bot_flutter/pages/quant_page/trend_follow/trend_follow_quant_table.dart';
import 'package:quant_bot_flutter/providers/auth_provider.dart';
import 'package:quant_bot_flutter/providers/loading_provider.dart';
import 'package:quant_bot_flutter/providers/quant_provider.dart';
import 'package:quant_bot_flutter/providers/router_provider.dart';

class TrendFollowDetailPage extends ConsumerStatefulWidget {
  final TrendFollowArgs tfargs;

  const TrendFollowDetailPage({super.key, required this.tfargs});

  @override
  ConsumerState<TrendFollowDetailPage> createState() =>
      _TrendFollowDetailPageState();
}

class _TrendFollowDetailPageState extends ConsumerState<TrendFollowDetailPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final trendFollow = ref.watch(
      trendFollowProvider(
        TrendFollowArgs(
            ticker: widget.tfargs.ticker, assetType: widget.tfargs.assetType),
      ),
    );
    final ticker = widget.tfargs.ticker;
    return Scaffold(
      appBar: const QuantBotDetailPageHeader(
        title: '추세추종 전략 저장',
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
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
                          skeletonName:
                              SkeletonDetailPageLoading.stockInfoSkeleton,
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
                        skeletonName:
                            SkeletonDetailPageLoading.stockChartSkeleton,
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          children: [
                            const Text(
                              '추세 정보',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 77),
                              child: InkWell(
                                onTap: () async {
                                  await showQuantBotDialog(
                                    context: context,
                                    title: '추세추종 투자법 정보',
                                    content:
                                        '추세 추종 투자법은 시장의 상승 또는 하락 추세를 따라 매수하거나 매도하는 전략입니다.',
                                  );
                                },
                                child: Icon(
                                  CupertinoIcons.question_circle_fill,
                                  size: 18,
                                  color: CustomColors.brightYellow120,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: trendFollow.when(
                      data: (data) {
                        final recentStockData = data.recentStockOne;
                        return TrendFollowQuantTable(
                            recentStockOne: recentStockData);
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              text: '퀀트 알림 설정',
              onPressed: () => _handleQuantAlertSetting(
                  TrendFollowArgs(
                    ticker: widget.tfargs.ticker,
                    assetType: widget.tfargs.assetType,
                  ),
                  context),
              textColor: Colors.white,
              backgroundColor: CustomColors.clearBlue120,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleQuantAlertSetting(
      TrendFollowArgs args, BuildContext context) async {
    final loadingNotifier = ref.read(loadingProvider.notifier);
    final auth = await ref.read(authStorageProvider.future);
    if (auth == null) {
      CustomToast.show(message: '로그인이 필요합니다.', isWarn: true);

      if (!context.mounted) return;
      context.push(RouteNotifier.loginPath);
      return;
    }
    final notifier = ref.read(trendFollowProvider(args).notifier);
    try {
      isLoading = true;
      final trendFollowData = await ref.read(trendFollowProvider(args).future);
      final recentStockOne = trendFollowData.recentStockOne;

      final initialPrice = double.parse(recentStockOne.currentPrice);
      final initialTrendFollow =
          double.parse(recentStockOne.lastCrossTrendFollow);

      await loadingNotifier.runWithLoading(() async =>
          await notifier.addStockToProfile(args.ticker,
              QuantType.TREND_FOLLOW.code, initialPrice, initialTrendFollow));

      _showSuccessToast('퀀트 알림이 성공적으로 설정되었습니다.');
    } catch (e) {
      _showErrorToast(getErrorMessage(e));
    } finally {
      isLoading = false;
    }
  }

  void _showSuccessToast(String message) {
    CustomToast.show(message: message);
  }

  void _showErrorToast(String message) {
    CustomToast.show(message: message, isWarn: true);
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
