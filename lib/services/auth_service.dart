import 'dart:async';

class AuthService {
  /// 모의 인증: 클라이언트 측 기본 형식 검사만 수행
  static Future<bool> authenticate({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final emailRegex = RegExp(r"^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,}");
    if (!emailRegex.hasMatch(email)) {
      return false;
    }
    // 기본 패스워드 규칙 검사(재사용 가능한 유틸 사용)
    final errs = passwordValidationErrors(password);
    if (errs.isNotEmpty) return false;
    return true;
  }

  /// 비밀번호 규칙 검증
  /// 반환값: 실패한 규칙들의 간단한 메시지 리스트(순서: 길이, 소문자, 숫자, 특수문자)
  static List<String> passwordValidationErrors(String password) {
    final List<String> errors = [];
    if (password.length < 8) {
      errors.add('비밀번호는 최소 8자 이상이어야 합니다.');
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      errors.add('소문자를 하나 이상 포함해야 합니다.');
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      errors.add('숫자를 하나 이상 포함해야 합니다.');
    }
    if (!password.contains(RegExp(r'[!@#\$%\^&*(),.?":{}|<>]'))) {
      errors.add('특수문자를 하나 이상 포함해야 합니다.');
    }
    return errors;
  }
}
