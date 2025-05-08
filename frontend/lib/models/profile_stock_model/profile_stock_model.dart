class ProfileStockModel {
  final String id;
  final String ticker;
  final String name;
  final String quantType;
  final bool notification;
  final String profit;
  final String profitPercent;
  final String initialStatus;
  final String currentStatus;

  ProfileStockModel({
    required this.id,
    required this.ticker,
    required this.name,
    required this.quantType,
    required this.notification,
    required this.profit,
    required this.profitPercent,
    required this.initialStatus,
    required this.currentStatus,
  });

  factory ProfileStockModel.fromJson(Map<String, dynamic> json) {
    return ProfileStockModel(
      id: json['id'],
      ticker: json['ticker'],
      name: json['name'],
      quantType: json['quant_type'],
      notification: json['notification'],
      profit: json['profit'],
      profitPercent: json['profit_percent'],
      initialStatus: json['initial_status'],
      currentStatus: json['current_status'],
    );
  }
}
