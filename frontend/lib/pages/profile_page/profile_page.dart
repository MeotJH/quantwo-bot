import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quant_bot/components/custom_dialog.dart';
import 'package:quant_bot/constants/quant_type.dart';
import 'package:quant_bot/common/colors.dart';
import 'package:quant_bot/constants/router_path_constants.dart';
import 'package:quant_bot/models/profile_stock_model/profile_stock_model.dart';
import 'package:quant_bot/pages/loading_pages/profile_info_skeleton.dart';
import 'package:quant_bot/providers/dio_provider.dart';
import 'package:quant_bot/providers/profile_provider.dart';
import 'package:quant_bot/pages/loading_pages/skeleton_list_loading.dart';
import 'package:quant_bot/services/push_service.dart/push_service.dart';

class ProfilePage extends ConsumerWidget {
  ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileStocks = ref.watch(profileStocksProvider);
    final profileInfo = ref.watch(profileInfoNotifier);
    final dio = ref.read(dioProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 프로필',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        color: const Color(0xFFF0F0F0),
        child: Column(
          children: [
            profileInfo.when(
              data: (user) => Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.white,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: CustomColors.gray40,
                            child: const Icon(Icons.person,
                                size: 40, color: Colors.white),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.userName,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text(user.email,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('알림', style: TextStyle(fontSize: 14)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 0),
                          child: Switch(
                            value: user.notification,
                            activeColor: CustomColors.clearBlue100,
                            onChanged: (bool value) async {
                              ref
                                  .read(profileInfoNotifier.notifier)
                                  .toggleNotification(value);
                              WebPushService webPushService =
                                  WebPushService(dio: dio);
                              if (!value) {
                                webPushService.togglePush(isToggle: false);
                                return;
                              }
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              loading: () => const ProfileInfoSkeleton(),
              error: (error, stack) => Text('프로필 정보 로딩 오류: $error'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: profileStocks.when(
                data: (stocks) => _buildStockList(stocks, ref),
                loading: () => const Center(child: SkeletonLoadingList()),
                error: (error, stack) => Center(
                  child: Text('오류가 발생했습니다: $error'),
                ),
              ),
            ),
            //여기
          ],
        ),
      ),
    );
  }

  Widget _buildStockList(List<ProfileStockModel> stocks, WidgetRef ref) {
    return ListView.builder(
      itemCount: stocks.length + 1,
      itemBuilder: (context, index) {
        if (index == stocks.length) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: InkWell(
              onTap: () {
                context.push(RouterPath.strategySelectPath);
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: CustomColors.gray100,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '퀀트 추가하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: CustomColors.gray100,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final stock = stocks[index];
        return InkWell(
          onTap: () {
            navigateToQuantPage(context, stock);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 3,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: CustomColors.jadeGreen120.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            QuantType.fromCode(stock.quantType)
                                .name
                                .toUpperCase(),
                            style: TextStyle(
                              color: CustomColors.jadeGreen120,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          stock.initialStatus == stock.currentStatus
                              ? '포지션 유지: ${stock.initialStatus.toUpperCase()}'
                              : '포지션 변화: ${stock.initialStatus.toUpperCase()} -> ${stock.currentStatus.toUpperCase()}',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              stock.ticker.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 12, color: CustomColors.gray60),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              stock.name,
                              style: TextStyle(
                                  fontSize: 10, color: CustomColors.gray40),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "알림 기준 ${double.parse(stock.profit) >= 0 ? '수익' : '예방 손해'}",
                    style: TextStyle(
                      fontSize: 11,
                      color: CustomColors.gray50,
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 3),
                        child: Column(
                          children: [
                            Text(
                              '\$${stock.profit}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: double.parse(stock.profit) >= 0
                                    ? CustomColors.error
                                    : Colors.blue,
                              ),
                            ),
                            Row(
                              children: [
                                double.parse(stock.profit) >= 0
                                    ? Icon(Icons.trending_up,
                                        color: CustomColors.error)
                                    : Icon(
                                        Icons.trending_down,
                                        color: CustomColors.clearBlue120,
                                      ),
                                Text(
                                  '${stock.profitPercent}%',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: double.parse(stock.profit) >= 0
                                        ? CustomColors.error
                                        : Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.delete_forever,
                              color: CustomColors.error,
                              size: 16,
                            ),
                            onPressed: () async {
                              await showQuantBotDialog(
                                context: context,
                                title: '퀀트 삭제',
                                content: '삭제 하시겠습니까?',
                                isAlert: false,
                                setPositiveAction: () async {
                                  ref
                                      .read(profileStocksProvider.notifier)
                                      .deleteQuant(stock);
                                },
                              );
                            },
                            constraints: const BoxConstraints(),
                            //padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.notifications,
                              color: stock.notification
                                  ? CustomColors.brightYellow100
                                  : CustomColors.gray50,
                              size: 20,
                            ),
                            onPressed: () {
                              ref
                                  .read(profileStocksProvider.notifier)
                                  .toggleNotification(stock);
                            },
                            constraints: const BoxConstraints(),
                            //padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void navigateToQuantPage(BuildContext context, ProfileStockModel stock) {
    final route = quantRouteMap[QuantType.fromCode(stock.quantType)];
    if (route != null) {
      context.push(route(stock));
    } else {
      throw Exception("Unsupported Quant Type: ${stock.quantType}");
    }
  }

  final Map<QuantType, String Function(ProfileStockModel stock)> quantRouteMap =
      {
    QuantType.TREND_FOLLOW: (stock) =>
        '/quant-form/quant/trend-follow/${stock.ticker}',
    QuantType.DUAL_MOMENTUM_INTL: (_) =>
        RouterPath.dualMomentumInternationalPath,
  };
}
