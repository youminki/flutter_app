import 'package:flutter/material.dart';
import '../services/auth_service.dart';

/// 비밀번호 규칙 실시간 표시
class PasswordRules extends StatelessWidget {
  const PasswordRules({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final pwd = value.text;
        if (pwd.isEmpty) return const SizedBox.shrink();
        final errs = AuthService.passwordValidationErrors(pwd);
        if (errs.isEmpty) return const SizedBox.shrink();
        final first = errs.first;
        // 간단한 애니메이션과 빨간 강조로 첫 실패 항목 표시
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 4),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Row(
              key: ValueKey(first),
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 16,
                  color: Colors.redAccent,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    first,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
