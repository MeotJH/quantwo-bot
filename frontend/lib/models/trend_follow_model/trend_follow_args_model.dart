class TrendFollowArgs {
  final String ticker;
  final String assetType;

  const TrendFollowArgs({
    this.ticker = 'aapl',
    this.assetType = 'us',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrendFollowArgs &&
          runtimeType == other.runtimeType &&
          ticker == other.ticker &&
          assetType == other.assetType;

  @override
  int get hashCode => ticker.hashCode ^ assetType.hashCode;
}
