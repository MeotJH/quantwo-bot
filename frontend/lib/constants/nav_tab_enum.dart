import 'package:flutter/material.dart';
import 'package:quant_bot_flutter/constants/router_path_constants.dart';
import 'package:quant_bot_flutter/providers/router_provider.dart';

enum NavTab {
  stocks(
    idx: 0,
    path: RouterPath.stockListPath,
    icon: Icons.show_chart_rounded,
    label: 'Stocks',
  ),
  quants(
    idx: 1,
    path: RouterPath.strategySelectPath,
    icon: Icons.add_chart,
    label: 'Quants',
  ),
  tools(
    idx: 2,
    path: RouterPath.toolsPath,
    icon: Icons.smart_toy_outlined,
    label: 'Tools',
  ),
  profile(
    idx: 3,
    path: RouterPath.profilePath,
    icon: Icons.person,
    label: 'Profile',
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
