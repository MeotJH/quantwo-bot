import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonDetailPageLoading extends StatelessWidget {
  static const String stockInfoSkeleton = 'StockInfoSkeleton';
  static const String stockChartSkeleton = 'StockChartSkeleton';
  static const String trendFollowCardSkeleton = 'TrendFollowCardSkeleton';
  static const String stockInfoCardSkeleton = 'StockDetailInfoSkeleton';

  final String skeletonName;
  const SkeletonDetailPageLoading({super.key, required this.skeletonName});
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SkeletonItems(
        skeletonName: skeletonName,
      ),
    );
  }
}

class SkeletonItems extends StatelessWidget {
  final String skeletonName;
  SkeletonItems({super.key, required this.skeletonName});

  final Map<String, Widget> skeletonMap = {
    SkeletonDetailPageLoading.stockInfoSkeleton: const StockInfoSkeleton(),
    SkeletonDetailPageLoading.stockChartSkeleton: const StockChartSkeleton(),
    SkeletonDetailPageLoading.trendFollowCardSkeleton:
        const StockContainerSkeleton(),
    SkeletonDetailPageLoading.stockInfoCardSkeleton:
        const StockContainerSkeleton(),
  };
  @override
  Widget build(BuildContext context) {
    return skeletonMap[skeletonName] ?? const StockInfoSkeleton();
  }
  //스프링 클라우드, AWS (SQS, ROUTE53, CoudFront, S3,) Cloud Batch
  // 8인 정도
  //
}

class StockInfoSkeleton extends StatelessWidget {
  const StockInfoSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    const radius = 8.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
          ),
          width: 100,
          height: 16,
        ),
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
          ),
          width: 50,
          height: 16,
        ),
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
          ),
          width: 180,
          height: 32,
        ),
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
          ),
          width: 30,
          height: 12,
        ),
      ],
    );
  }
}

class StockChartSkeleton extends StatelessWidget {
  const StockChartSkeleton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            width: double.infinity,
            height: 300,
          ),
        ),
      ],
    );
  }
}

class StockContainerSkeleton extends StatelessWidget {
  const StockContainerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(4),
                    width: constraints.maxWidth * 0.3,
                    height: 16.0,
                    color: Colors.white,
                  ),
                  Container(
                    margin: const EdgeInsets.all(4),
                    width: constraints.maxWidth * 0.2,
                    height: 16.0,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(4),
                    width: constraints.maxWidth * 0.3,
                    height: 16.0,
                    color: Colors.white,
                  ),
                  Container(
                    margin: const EdgeInsets.all(4),
                    width: constraints.maxWidth * 0.2,
                    height: 16.0,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(4),
                    width: constraints.maxWidth * 0.3,
                    height: 16.0,
                    color: Colors.white,
                  ),
                  Container(
                    margin: const EdgeInsets.all(4),
                    width: constraints.maxWidth * 0.2,
                    height: 16.0,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
