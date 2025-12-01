import 'dart:async';

class AuthService {
  /// 모의 인증: 클라이언트 측 기본 형식 검사만 수행
  static Future<bool> authenticate({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final emailRegex = RegExp(r"^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,}");
    if (!emailRegex.hasMatch(email)) return false;
    if (password.length < 8) return false;
    return true;
  }
}
