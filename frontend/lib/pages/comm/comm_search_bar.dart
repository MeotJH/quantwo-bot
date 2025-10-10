import 'package:flutter/material.dart';
import 'package:quant_bot/common/colors.dart';

typedef SearchHandler = void Function(String query);

class CommSearchField extends StatefulWidget {
  const CommSearchField(
      {super.key, required this.hintText, required this.onQueryChanged});

  final String hintText;
  final SearchHandler onQueryChanged;

  @override
  State<CommSearchField> createState() => _StocksPageSearchBarState();
}

class _StocksPageSearchBarState extends State<CommSearchField> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void onChanged(String value) {
      widget.onQueryChanged(value);
    }

    return TextField(
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.search),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: CustomColors.white,
      ),
      controller: _controller,
      onChanged: onChanged,
    );
  }
}
