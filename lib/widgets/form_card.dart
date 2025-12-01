import 'package:flutter/material.dart';

/// Card + Form wrapper used across pages to keep consistent padding and style.
class FormCard extends StatelessWidget {
  const FormCard({
    super.key,
    required this.formKey,
    required this.child,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  final GlobalKey<FormState> formKey;
  final Widget child;
  final AutovalidateMode autovalidateMode;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Form(
        key: formKey,
        autovalidateMode: autovalidateMode,
        child: child,
      ),
    );
  }
}
