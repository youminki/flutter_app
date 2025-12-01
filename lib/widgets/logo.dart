import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 앱 로고 위젯
class Logo extends StatelessWidget {
  const Logo({super.key, this.height = 80});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: SvgPicture.asset('assets/logo.svg', fit: BoxFit.contain),
    );
  }
}
