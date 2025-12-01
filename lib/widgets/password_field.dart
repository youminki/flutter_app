import 'package:flutter/material.dart';
import '../styles/styles.dart';
import 'password_rules.dart';

/// 비밀번호 입력 필드 (내부에서 가시성 토글 및 blur 시 규칙 표시)
class PasswordField extends StatefulWidget {
  const PasswordField({super.key, required this.controller, this.fillColor});

  final TextEditingController controller;
  final Color? fillColor;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;
  bool _showRules = false;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      // blur: 규칙 검사 후 필요하면 표시
      final pwd = widget.controller.text;
      final lenOk = pwd.length >= 8;
      final lower = pwd.contains(RegExp(r'[a-z]'));
      final digit = pwd.contains(RegExp(r'[0-9]'));
      final special = pwd.contains(RegExp(r'[!@#\$%\^&*(),.?":{}|<>]'));
      final allOk = lenOk && lower && digit && special;
      setState(() => _showRules = pwd.isNotEmpty && !allOk);
    } else {
      setState(() => _showRules = false);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fc = widget.fillColor ?? AppColors.fill;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: widget.controller,
          obscureText: _obscure,
          focusNode: _focusNode,
          decoration: InputDecoration(
            filled: true,
            fillColor: fc,
            hintText: '비밀번호',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none,
            ),
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: widget.controller,
              builder: (context, value, _) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (value.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => widget.controller.clear(),
                    ),
                  IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ],
              ),
            ),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return '비밀번호를 입력하세요.';
            if (v.length < 8) return '비밀번호는 최소 8자 이상이어야 합니다.';
            return null;
          },
        ),
        if (_showRules) ...[
          const SizedBox(height: AppSpacing.sm),
          PasswordRules(controller: widget.controller),
        ],
      ],
    );
  }
}
