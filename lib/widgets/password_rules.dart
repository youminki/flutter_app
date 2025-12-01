import 'package:flutter/material.dart';
import '../styles/styles.dart';

/// 비밀번호 규칙 실시간 표시
class PasswordRules extends StatelessWidget {
  const PasswordRules({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    Widget rule(bool ok, String text) => Row(
      children: [
        Icon(
          ok ? Icons.check_circle : Icons.close,
          size: 14,
          color: ok ? AppColors.success : AppColors.muted,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: ok ? AppColors.success : AppColors.muted,
          ),
        ),
      ],
    );

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final pwd = value.text;
        if (pwd.isEmpty) return const SizedBox.shrink();
        final lenOk = pwd.length >= 8;
        final upper = pwd.contains(RegExp(r'[A-Z]'));
        final lower = pwd.contains(RegExp(r'[a-z]'));
        final digit = pwd.contains(RegExp(r'[0-9]'));
        final special = pwd.contains(RegExp(r'[!@#\$%\^&*(),.?":{}|<>]'));
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              rule(lenOk, '8자 이상'),
              rule(upper, '대문자 포함'),
              rule(lower, '소문자 포함'),
              rule(digit, '숫자 포함'),
              rule(special, '특수문자 포함 (!@#...)'),
            ],
          ),
        );
      },
    );
  }
}
