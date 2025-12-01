import 'package:flutter/material.dart';

/// 앱 전역 색상 및 간격 정의
class AppColors {
  AppColors._();

  // 버튼/강조 색상
  static const Color primary = Color(0xFF000000); // 검정
  // 메인 컬러: rgb(246,174,36) -> #F6AE24
  static const Color accent = Color(0xFFF6AE24); // 강조 색

  // 입력 채우기 배경
  static Color fill = Colors.blue.shade50;

  // 상태 색
  static const Color success = Color(0xFF2E7D32);
  static const Color danger = Color(0xFFD32F2F);

  // 보조 텍스트
  static const Color muted = Color(0xFF616161);
}

/// 공통 간격
class AppSpacing {
  AppSpacing._();
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 18.0;
  static const double xl = 24.0;
}

ThemeData buildAppTheme() => ThemeData(
  primaryColor: AppColors.primary,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.blue,
  ).copyWith(secondary: AppColors.accent),
);
