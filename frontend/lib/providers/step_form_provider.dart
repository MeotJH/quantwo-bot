import 'package:flutter_riverpod/flutter_riverpod.dart';

enum StrategyType {
  defensive,
  aggressive;

  String get name {
    switch (this) {
      case StrategyType.defensive:
        return '방어형';
      case StrategyType.aggressive:
        return '공격형';
    }
  }
}

// 멀티스텝 폼에서 사용될 모든 데이터를 담는 모델
class StepFormModel {
  final StrategyType? strategy;
  final String? quantType; // 'TF', 'MM' 등
  final String? ticker; // 주식 심볼
  final double? investmentAmount; // 투자금액
  // ... 추가될 수 있는 다른 필드들

  StepFormModel({
    this.strategy,
    this.quantType,
    this.ticker,
    this.investmentAmount,
  });

  StepFormModel copyWith({
    StrategyType? strategy,
    String? quantType,
    String? ticker,
    double? investmentAmount,
  }) {
    return StepFormModel(
      strategy: strategy ?? this.strategy,
      quantType: quantType ?? this.quantType,
      ticker: ticker ?? this.ticker,
      investmentAmount: investmentAmount ?? this.investmentAmount,
    );
  }
}

final stepFormProvider = StateNotifierProvider<StepFormNotifier, StepFormModel>(
  (ref) => StepFormNotifier(),
);

class StepFormNotifier extends StateNotifier<StepFormModel> {
  StepFormNotifier() : super(StepFormModel());

  void setStrategy(StrategyType strategy) {
    state = state.copyWith(strategy: strategy);
  }

  void setQuantType(String quantType) {
    state = state.copyWith(quantType: quantType);
  }

  void setTicker(String ticker) {
    state = state.copyWith(ticker: ticker);
  }

  void setInvestmentAmount(double amount) {
    state = state.copyWith(investmentAmount: amount);
  }

  void reset() {
    state = StepFormModel();
  }
}
