import 'package:flutter/material.dart';
import 'package:quant_bot/constants/quant_type.dart';
import 'package:quant_bot/providers/step_form_provider.dart';

class QuantStrategyModel {
  final String name;
  final String description;
  final String type;
  final String profitDescription;
  final String riskDescription;
  final IconData icon;
  final String route;

  const QuantStrategyModel({
    required this.name,
    required this.description,
    required this.type,
    required this.profitDescription,
    required this.riskDescription,
    required this.icon,
    required this.route,
  });

  static List<QuantStrategyModel> getStrategiesByType(StrategyType type) {
    switch (type) {
      case StrategyType.defensive:
        return [
          QuantStrategyModel(
            name: '추세추종 전략',
            description: '주식의 추세를 따라가는 안정적인 전략',
            type: QuantType.TREND_FOLLOW.code,
            profitDescription: '연 수익률 15~20%',
            riskDescription: '최대 손실률 10%',
            icon: Icons.show_chart,
            route: '/quant-form/quant/trend-follow/description',
          ),
          QuantStrategyModel(
            name: '국제 ETF 듀얼모멘텀',
            description: '미국, 유럽, 일본, 한국에 투자하는 듀얼모멘텀 전략',
            type: QuantType.DUAL_MOMENTUM_INTL.code,
            profitDescription: '연 수익률 6~8%',
            riskDescription: '최대 손실률 3%',
            icon: Icons.show_chart,
            route: '/quant-form/quant/dual-momentum/international/description',
          ),
          // const QuantStrategyModel(
          //   name: '듀얼모멘텀 전략 2',
          //   description: '글로벌 주식 듀얼모멘텀',
          //   type: 'DM2',
          //   profitDescription: '연 수익률 10~15%',
          //   riskDescription: '최대 손실률 12%',
          //   icon: Icons.show_chart,
          //   route: '/quant-form/ticker',
          // ),
        ];
      case StrategyType.aggressive:
        return [
          const QuantStrategyModel(
            name: '모멘텀 전략',
            description: '상승 모멘텀이 강한 주식에 투자',
            type: 'MM',
            profitDescription: '연 수익률 25~30%',
            riskDescription: '최대 손실률 20%',
            icon: Icons.trending_up,
            route: '/quant-form/ticker',
          ),
        ];
    }
  }
}
