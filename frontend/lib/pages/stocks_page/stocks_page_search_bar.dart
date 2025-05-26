import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quant_bot_flutter/common/colors.dart';
import 'package:quant_bot_flutter/providers/stock_providers/crypto_currency_provider.dart';
import 'package:quant_bot_flutter/providers/stock_providers/stock_tab_provier.dart';
import 'package:quant_bot_flutter/providers/stock_providers/stocks_provider.dart';

class StocksPageSearchBar extends ConsumerStatefulWidget {
  final int tabIndex;
  const StocksPageSearchBar(this.tabIndex, {super.key});

  @override
  ConsumerState<StocksPageSearchBar> createState() =>
      _StocksPageSearchBarState();
}

class _StocksPageSearchBarState extends ConsumerState<StocksPageSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final stocksNotifier = ref.watch(stocksProvider.notifier);
    final cryptoCurrencyNotifier = ref.watch(cryptoCurrencyProvider.notifier);
    final tabIndex = ref.watch(tabIndexProvider);
    return TextField(
      decoration: InputDecoration(
        hintText: tabIndex == 0
            ? 'Search : 주식을 \'영문\'으로 검색해주세요.'
            : 'Search : 코인을 검색해주세요.',
        prefixIcon: const Icon(Icons.search),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: CustomColors.white,
      ),
      controller: _controller,
      onChanged: (value) => tabIndex == 0
          ? stocksNotifier.searchStocks(query: value)
          : cryptoCurrencyNotifier.searchStocks(query: value),
    );
  }
}
