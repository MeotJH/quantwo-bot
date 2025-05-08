import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot_flutter/core/colors.dart';
import 'package:quant_bot_flutter/providers/stocks_provider.dart';

class TrendFollowSearchBar extends ConsumerStatefulWidget {
  const TrendFollowSearchBar({super.key});

  @override
  ConsumerState<TrendFollowSearchBar> createState() =>
      _TrendFollowSearchBarState();
}

class _TrendFollowSearchBarState extends ConsumerState<TrendFollowSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final stocksNotifier = ref.watch(stocksProvider.notifier);
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search : Ticker 를 검색해주세요. 예) AAPL',
        prefixIcon: const Icon(Icons.search),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: CustomColors.white,
      ),
      controller: _controller,
      onChanged: (value) => stocksNotifier.searchStocks(query: value),
    );
  }
}
