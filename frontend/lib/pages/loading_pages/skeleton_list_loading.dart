import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoadingList extends StatelessWidget {
  const SkeletonLoadingList({super.key});

  @override
  Widget build(BuildContext context) {
    var baseColor = 500;
    var highlightColor = 100;
    return ListView.builder(
      itemCount: 4, // 임의의 로딩 아이템 개수
      itemBuilder: (context, index) {
        if (baseColor > 0) baseColor = baseColor - 100;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[baseColor]!,
            highlightColor: Colors.grey[highlightColor]!,
            child: const SkeletonItem(),
          ),
        );
      },
    );
  }
}

class SkeletonItem extends StatelessWidget {
  const SkeletonItem({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32.0,
                  height: 16.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 8.0),
                Container(
                  width: double.infinity,
                  height: 16.0,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            width: 100,
            height: 32.0,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.zero,
            ),
          ),
          const SizedBox(width: 16.0),
          // 텍스트 로딩
        ],
      ),
    );
  }
}
