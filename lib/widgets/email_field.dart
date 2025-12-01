import 'package:flutter/material.dart';
import '../styles/styles.dart';

/// 이메일 입력 필드 + 실시간 형식 피드백
class EmailField extends StatelessWidget {
  const EmailField({super.key, required this.controller, this.fillColor});

  final TextEditingController controller;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    final fc = fillColor ?? AppColors.fill;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            filled: true,
            fillColor: fc,
            hintText: '이메일',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none,
            ),
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, _) => value.text.isEmpty
                  ? const SizedBox.shrink()
                  : IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => controller.clear(),
                    ),
            ),
          ),
          validator: (v) {
            if (v == null || v.trim().isEmpty) return '이메일을 입력하세요.';
            final email = v.trim();
            final emailRegex = RegExp(r"^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,}");
            if (!emailRegex.hasMatch(email)) return '유효한 이메일을 입력하세요.';
            return null;
          },
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            final txt = value.text.trim();
            if (txt.isEmpty) return const SizedBox.shrink();
            final ok = RegExp(
              r"^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,}",
            ).hasMatch(txt);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 4),
              child: Row(
                children: [
                  Icon(
                    ok ? Icons.check_circle : Icons.error,
                    size: 16,
                    color: ok ? AppColors.success : AppColors.danger,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    ok ? '유효한 이메일 형식' : '유효하지 않은 이메일 형식',
                    style: TextStyle(
                      fontSize: 12,
                      color: ok ? AppColors.success : AppColors.danger,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
