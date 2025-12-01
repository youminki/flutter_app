import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_input.dart';

/// PhoneField: phone formatting and basic validation encapsulated.
class PhoneField extends StatelessWidget {
  const PhoneField({
    super.key,
    required this.controller,
    this.hintText = '010-1234-5678',
    this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final FormFieldValidator<String>? validator;

  static final TextInputFormatter _phoneFormatter =
      TextInputFormatter.withFunction((oldValue, newValue) {
        final digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
        String formatted;
        if (digits.length <= 3) {
          formatted = digits;
        } else if (digits.length <= 7) {
          formatted = '${digits.substring(0, 3)}-${digits.substring(3)}';
        } else {
          final part1 = digits.substring(0, 3);
          final part2 = digits.substring(3, 7);
          final part3 = digits.substring(
            7,
            digits.length > 11 ? 11 : digits.length,
          );
          formatted = '$part1-$part2${part3.isEmpty ? '' : '-$part3'}';
        }
        return TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      });

  @override
  Widget build(BuildContext context) {
    return AppInput(
      controller: controller,
      hintText: hintText,
      keyboardType: TextInputType.phone,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        _phoneFormatter,
      ],
      validator: validator,
    );
  }
}
