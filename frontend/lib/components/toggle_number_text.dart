import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:number_display/number_display.dart';

class ToggleNumberText extends StatefulWidget {
  final double? value;
  final int displayLength;
  final Color? color;
  final TextStyle? style;
  final String? prefix;
  final String? suffix;

  const ToggleNumberText({
    super.key,
    required this.value,
    this.displayLength = 6,
    this.prefix,
    this.suffix,
    this.color,
    this.style,
  });

  @override
  State<ToggleNumberText> createState() => _ToggleNumberTextState();
}

class _ToggleNumberTextState extends State<ToggleNumberText> {
  bool _isCompact = true;

  String _formatFull(double value) {
    final formatter = NumberFormat('#,###.##');
    return formatter.format(value);
  }

  String _formatCompact(double value) {
    final display = createDisplay(length: widget.displayLength);
    return display(value);
  }

  // 1000 이상일 때만 축약 의미 있음
  bool _shouldUseCompact(double value) {
    return value >=
        pow(10, widget.displayLength).toDouble(); // 10^widget.displayLength
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
