import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _obscure = true;
  bool _keepLoggedIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    // 모의 인증: 이메일이 test@example.com 이고 비밀번호가 1234 라면 성공
    await Future.delayed(const Duration(milliseconds: 600));
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email == 'test@example.com' && password == '1234') {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('로그인 정보가 올바르지 않습니다.')));
    }

    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final fillColor = Colors.blue.shade50;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo / Title
                  Column(
                    children: [
                      // SVG logo (falls back to text if asset missing)
                      SizedBox(
                        height: 80,
                        child: SvgPicture.asset(
                          'assets/LoginLogo.Bp1AByLd.svg',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 18),
                      // Headings
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                          children: [
                            const TextSpan(text: '이젠 '),
                            TextSpan(
                              text: '멜픽',
                              style: TextStyle(color: Colors.orange.shade700),
                            ),
                            const TextSpan(text: '을 통해\n브랜드를 골라보세요'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '사고, 팔고, 빌리는 것을 한번에!',
                        textAlign: TextAlign.center,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                      ),
                      const SizedBox(height: 28),
                    ],
                  ),

                  // Form
                  Card(
                    elevation: 0,
                    color: Colors.transparent,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Email
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: fillColor,
                              hintText: '이메일',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: _emailController.text.isEmpty
                                  ? null
                                  : IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () => setState(
                                        () => _emailController.clear(),
                                      ),
                                    ),
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return '이메일을 입력하세요.';
                              }
                              if (!v.contains('@')) {
                                return '유효한 이메일을 입력하세요.';
                              }
                              return null;
                            },
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 12),

                          // Password
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscure,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: fillColor,
                              hintText: '비밀번호',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide.none,
                              ),
                              suffixIcon: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_passwordController.text.isNotEmpty)
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () => setState(
                                        () => _passwordController.clear(),
                                      ),
                                    ),
                                  IconButton(
                                    icon: Icon(
                                      _obscure
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () =>
                                        setState(() => _obscure = !_obscure),
                                  ),
                                ],
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return '비밀번호를 입력하세요.';
                              }
                              if (v.length < 4) {
                                return '최소 4자 이상 입력하세요.';
                              }
                              return null;
                            },
                            onChanged: (_) => setState(() {}),
                          ),

                          const SizedBox(height: 12),

                          // Keep logged in row
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

                          // Login button
                          SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              onPressed: _loading ? null : _submit,
                              child: _loading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      '로그인',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Footer links
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
