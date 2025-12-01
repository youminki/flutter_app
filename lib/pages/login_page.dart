import 'package:flutter/material.dart';

import '../styles/styles.dart';
import '../services/auth_service.dart';
import '../widgets/logo.dart';
import '../widgets/email_field.dart';
import '../widgets/password_field.dart';
import '../widgets/password_rules.dart';
import '../widgets/auth_button.dart';

// 로그인 화면
// - 입력 컴포넌트를 조합하여 화면 구성
// - 실제 인증은 `AuthService`로 분리(현재는 모의 인증)

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // 폼 키 및 입력 컨트롤러
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // UI 상태
  bool _loading = false; // 로그인 처리 중 로딩 표시
  bool _keepLoggedIn = false; // 로그인 유지 여부

  @override
  void dispose() {
    // 컨트롤러 해제
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // 폼 검증 후 인증 시도 (AuthService 사용)
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final ok = await AuthService.authenticate(email: email, password: password);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pushReplacementNamed('/home');
      return;
    }
    setState(() => _loading = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('로그인 정보가 올바르지 않습니다.')));
  }

  @override
  Widget build(BuildContext context) {
    // 공통 색상/간격은 `AppColors` / `AppSpacing` 사용
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: 32,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 로고 표시
                  const Logo(),
                  const SizedBox(height: AppSpacing.lg),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                      children: [
                        const TextSpan(text: '이젠 '),
                        TextSpan(
                          text: '멜픽',
                          style: TextStyle(color: AppColors.accent),
                        ),
                        const TextSpan(text: '을 통해\n브랜드를 골라보세요'),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '사고, 팔고, 빌리는 것을 한번에!',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
                  ),
                  const SizedBox(height: 28),
                  Card(
                    elevation: 0,
                    color: Colors.transparent,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          EmailField(
                            controller: _emailController,
                            fillColor: AppColors.fill,
                          ),
                          const SizedBox(height: 4),
                          PasswordField(
                            controller: _passwordController,
                            fillColor: AppColors.fill,
                          ),
                          const SizedBox(height: 8),
                          PasswordRules(controller: _passwordController),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Checkbox(
                                value: _keepLoggedIn,
                                onChanged: (v) =>
                                    setState(() => _keepLoggedIn = v ?? false),
                              ),
                              const SizedBox(width: 6),
                              const Expanded(child: Text('로그인 상태 유지 (선택)')),
                            ],
                          ),
                          const SizedBox(height: 8),
                          AuthButton(loading: _loading, onPressed: _submit),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: const Text('아이디 찾기'),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text('비밀번호 찾기'),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: const Text('회원가입 (이메일)'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
