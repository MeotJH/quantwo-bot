import 'package:flutter/material.dart';
import 'package:quant_bot/constants/quant_type.dart';

class CustomDialogDropDown extends StatefulWidget {
  const CustomDialogDropDown({super.key});

  static Future<QuantType> showCustomDialog(BuildContext context) async {
    QuantType? selectedCategory = await showDialog<QuantType>(
      context: context,
      builder: (BuildContext context) {
        return const CustomDialogDropDown();
      },
    );

    // 카테고리가 선택되지 않았을 경우 기본 값을 제공합니다.
    return selectedCategory ?? QuantType.SELECT;
  }

  @override
  State<StatefulWidget> createState() => _CustomDialogDropDownState();
}

class _CustomDialogDropDownState extends State<CustomDialogDropDown> {
  final List<bool> isHovering =
      List<bool>.filled(QuantType.values.length, false);
  QuantType selectedCategory = QuantType.SELECT;

  @override
  Widget build(BuildContext context) {
    final int lastIndex = QuantType.values.length - 1;
    return AlertDialog(
      title: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Text('투자 방법 선택',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 0,
      contentPadding: const EdgeInsets.all(0),
      insetPadding: const EdgeInsets.all(0),
      content: SingleChildScrollView(
        child: Column(
          children: QuantType.values
              .where((item) => QuantType.values.indexOf(item) != lastIndex)
              .map((item) => _dropDownItem(item: item))
              .toList(),
        ),
      ),
    );
  }

  MouseRegion _dropDownItem({required QuantType item}) {
    int index = QuantType.values.indexOf(item);
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering[index] = true),
      onExit: (_) => setState(() => isHovering[index] = false),
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: () {
            setState(() {
              selectedCategory = item;
              Navigator.of(context).pop(item);
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.hovered) ||
                    states.contains(MaterialState.pressed)) {
                  return const Color(0xFF009999);
                }
                return Colors.white;
              },
            ),
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.hovered)) {
                  return Colors.white;
                }
                return Colors.black;
              },
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
