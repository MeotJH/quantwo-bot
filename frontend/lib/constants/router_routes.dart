import 'package:go_router/go_router.dart';
import 'package:quant_bot/constants/router_path_constants.dart';
import 'package:quant_bot/models/trend_follow_model/trend_follow_args_model.dart';
import 'package:quant_bot/pages/quant_page/dual_momentums/international/dual_momentum_international.dart';
import 'package:quant_bot/pages/quant_page/dual_momentums/international/dual_momentum_international_description.dart';
import 'package:quant_bot/pages/quant_page/trend_follow/trend_follow_description.dart';
import 'package:quant_bot/pages/quant_page/trend_follow/trend_follow_detail_page.dart';
import 'package:quant_bot/pages/quant_page/trend_follow/trend_follow_page.dart';
import 'package:quant_bot/pages/quant_select_page/quant_select_page.dart';
import 'package:quant_bot/pages/tool_pages/tools_lite_calculator_compound/tools_lite_calculator_compound.dart';
import 'package:quant_bot/pages/tool_pages/tools_lite_calculator_compound/tools_lite_calculator_compound_result.dart';
import 'package:quant_bot/pages/tool_pages/tools_page.dart';
import 'package:quant_bot/pages/tool_pages/tools_lite_calculator_retire/tools_lite_calculator_retire.dart';
import 'package:quant_bot/pages/tool_pages/tools_lite_page.dart';

List<GoRoute> quantTypeRoutes = [
  GoRoute(
    path: RouterPath.quantTypePath,
    builder: (context, state) => const QuantSelectPage(),
  ),
  GoRoute(
    path: RouterPath.trendFollowPath,
    builder: (context, state) => const TrendFollowPage(),
  ),
  GoRoute(
    path: RouterPath.trendFollowDescription,
    builder: (context, state) => const TrendFollowDescription(),
  ),
  GoRoute(
    path: RouterPath.trendFollowDetailPath,
    builder: (context, state) => TrendFollowDetailPage(
      tfargs: TrendFollowArgs(
        ticker: state.pathParameters['ticker']!,
        assetType: 'us',
      ),
    ),
  ),
  GoRoute(
    path: RouterPath.internationalDualMomentumPath,
    builder: (context, state) => const DualMomentumInternational(),
  ),
  GoRoute(
    path: RouterPath.internationDualMomentumDescriptionPath,
    builder: (context, state) => const DualMomentuInternationalDescription(),
  ),
];

List<GoRoute> toolsRoutes = [
  GoRoute(
    path: RouterPath.tools,
    builder: (context, state) => const ToolsPage(),
  ),
  GoRoute(
    path: RouterPath.toolsLite,
    builder: (context, state) => const ToolsLitePage(),
  ),
  GoRoute(
    path: RouterPath.toolsLiteRetire,
    builder: (context, state) => const ToolsLiteCalculatorRetire(),
  ),
  GoRoute(
    path: RouterPath.toolsLiteCompound,
    builder: (context, state) => const ToolsLiteCalculatorCompound(),
  ),
  GoRoute(
    path: RouterPath.toolsLiteCompoundResult,
    builder: (context, state) => const ToolsLiteCalculatorCompoundResult(),
  ),
];
