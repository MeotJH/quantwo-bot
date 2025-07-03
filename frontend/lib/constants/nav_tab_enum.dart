import 'package:flutter/material.dart';
import 'package:quant_bot/constants/router_path_constants.dart';

enum NavTab {
  stocks(
    idx: 0,
    path: RouterPath.stockListPath,
    icon: Icons.show_chart_rounded,
    label: '주식정보',
  ),
  quants(
    idx: 1,
    path: RouterPath.strategySelectPath,
    icon: Icons.add_chart,
    label: '퀀트투자',
  ),
  tools(
    idx: 2,
    path: RouterPath.tools,
    icon: Icons.smart_toy_outlined,
    label: '도구',
  ),
  profile(
    idx: 3,
    path: RouterPath.profilePath,
    icon: Icons.person,
    label: '내 정보',
  );

  final int idx;
  final String path;
  final IconData icon;
  final String label;

  const NavTab({
    required this.idx,
    required this.path,
    required this.icon,
    required this.label,
  });

  static NavTab fromPath(String path) {
    return NavTab.values.firstWhere(
      (tab) => path.startsWith(tab.path),
      orElse: () => NavTab.stocks,
    );
  }

  static NavTab fromIndex(int idx) {
    return NavTab.values.firstWhere((tab) => tab.idx == idx);
  }
}
