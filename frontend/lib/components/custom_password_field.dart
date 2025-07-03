import 'package:flutter/material.dart';
import 'package:quant_bot/common/colors.dart';

class CustomPasswordTextField extends StatefulWidget {
  const CustomPasswordTextField({
    super.key,
    required this.controller,
    this.errorText,
  });

  final TextEditingController controller;
  final String? errorText;

  @override
  State<CustomPasswordTextField> createState() =>
      _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  bool _obscureText = true;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _errorText = widget.errorText; // 초기화
    widget.controller.addListener(_validatePassword);
  }

  @override
  void didUpdateWidget(covariant CustomPasswordTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 부모로부터 전달된 errorText가 변경되면, 상태를 업데이트
    if (widget.errorText != oldWidget.errorText) {
      setState(() {
        _errorText = widget.errorText;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_validatePassword);
    super.dispose();
  }

  void _validatePassword() {
    // 비밀번호가 입력될 때마다 유효성을 확인하고 상태 업데이트
    setState(() {
      _errorText = widget.errorText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.next,
      obscureText: _obscureText,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CustomColors.gray40),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: CustomColors.black),
        ),
        errorText: _errorText,
      ),
      controller: widget.controller,
    );
  }
}
