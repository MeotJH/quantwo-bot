import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quant_bot_flutter/constants/currency_type_enu.dart';

class ToggleNumberText extends StatefulWidget {
  final double? value;
  final int displayLength;
  final Color? color;
  final TextStyle? style;
  final String? prefix;
  final String? suffix;
  final CurrencyType? currencyType;

  const ToggleNumberText({
    super.key,
    required this.value,
    this.displayLength = 6,
    this.prefix,
    this.suffix,
    this.color,
    this.style,
    this.currencyType,
  });

  @override
  State<ToggleNumberText> createState() => _ToggleNumberTextState();
}

class _ToggleNumberTextState extends State<ToggleNumberText> {
  bool _isCompact = true;
  Timer? _timer;

  String _formatFull(double value) {
    final formatter = NumberFormat('#,###.##');
    return formatter.format(value);
  }

  String _formatCompact(double value) {
    final currencyType = widget.currencyType ?? CurrencyType.USD;
    final display = currencyType.displayFunc(
        length: widget.displayLength, separator: ',', decimal: 2);
    //final display = createDisplay(length: widget.displayLength);
    return display(value);
  }

  // 1000 이상일 때만 축약 의미 있음
  bool _shouldUseCompact(double value) {
    return value >=
        pow(10, widget.displayLength).toDouble(); // 10^widget.displayLength
  }

  @override
  void initState() {
    super.initState();

    final value = widget.value ?? 0.0;
    final shouldToggle = _shouldUseCompact(value);
    if (!shouldToggle) return;

    setState(() => _isCompact = !_isCompact);
    // 최초 프레임 렌더링이 끝난 뒤 실행
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!shouldToggle) return;

      // 1. 유저가 화면을 보면 최초 1회 실행
      setState(() => _isCompact = !_isCompact);

      // 2. 이후 5초마다 실행
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (!mounted) return;
        setState(() => _isCompact = !_isCompact);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.value ?? 0.0;
    final text = _isCompact ? _formatCompact(value) : _formatFull(value);
    final displayText = '${widget.prefix ?? ''}$text${widget.suffix ?? ''}';

    return GestureDetector(
      onTap: () {
        final value = widget.value ?? 0.0;
        final shouldToggle = _shouldUseCompact(value);

        if (shouldToggle) {
          setState(() => _isCompact = !_isCompact);
        }
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: SizeTransition(
                sizeFactor: animation,
                axis: Axis.horizontal,
                child: child,
              ),
            );
          },
          child: Text(
            displayText,
            key: ValueKey(_isCompact),
            style: widget.style?.copyWith(color: widget.color) ??
                TextStyle(
                  fontSize: _isCompact ? 16 : 12,
                  fontWeight: FontWeight.bold,
                  color: widget.color ?? Colors.black,
                ),
          ),
        ),
      ),
    );
  }
}
