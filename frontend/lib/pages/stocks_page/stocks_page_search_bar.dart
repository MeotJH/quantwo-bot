import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot_flutter/common/colors.dart';
import 'package:quant_bot_flutter/providers/stocks_provider.dart';

class StocksPageSearchBar extends ConsumerStatefulWidget {
  const StocksPageSearchBar({super.key});

  @override
  ConsumerState<StocksPageSearchBar> createState() =>
      _StocksPageSearchBarState();
}

class _StocksPageSearchBarState extends ConsumerState<StocksPageSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final stocksNotifier = ref.watch(stocksProvider.notifier);
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search : 주식을 \'영문\'으로 검색해주세요.',
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
