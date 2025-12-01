import 'package:flutter/material.dart';
import '../widgets/logo.dart';
import '../widgets/form_card.dart';
import '../widgets/auth_button.dart';
import '../widgets/app_input.dart';
import '../widgets/phone_field.dart';
import '../widgets/select_field.dart';
import '../styles/styles.dart';

/// 아이디 찾기 페이지
class FindIdPage extends StatefulWidget {
  const FindIdPage({super.key});

  @override
  State<FindIdPage> createState() => _FindIdPageState();
}

class _FindIdPageState extends State<FindIdPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  int? _selectedYear;
  bool _loading = false;

  List<int> get _years {
    final now = DateTime.now().year;
    // show only current year down to (current year - 99) => 100 items
    return List<int>.generate(100, (i) => now - i);
  }

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return '이름을 입력해주세요.';
    return null;
  }

  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return '전화번호를 입력해주세요.';
    final cleaned = v.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.length < 10) return '유효한 전화번호를 입력해주세요.';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedYear == null) {
      if (_selectedYear == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('태어난 해를 선택해주세요.')));
      }
      return;
    }

    // 빠른 응답을 위해 인위적인 지연 제거
    setState(() => _loading = true);
    // 실제 네트워크 호출이 없으면 즉시 응답하도록 한다.
    // (필요하면 여기서 비동기 호출을 await 하도록 변경)
    if (!mounted) return;
    setState(() => _loading = false);

    final id =
        '${_nameController.text.trim().toLowerCase().replaceAll(' ', '')}@example.com';
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('아이디 찾기 결과'),
        content: Text('찾은 아이디: $id'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: 32,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  const Center(child: Logo(height: 80)),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text(
                      '이젠 멜픽을 통해\n브랜드를 골라보세요',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      '사고, 팔고, 빌리는 것을 한번에!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    '아이디 찾기',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  FormCard(
                    formKey: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        AppInput(
                          controller: _nameController,
                          hintText: '이름(한글)',
                          validator: _validateName,
                        ),
                        const SizedBox(height: 12),
                        SelectField<int>(
                          value: _selectedYear,
                          items: _years,
                          itemToString: (i) => i.toString(),
                          onChanged: (v) => setState(() => _selectedYear = v),
                          validator: (v) => v == null ? '태어난 해를 선택해주세요.' : null,
                          hintText: '태어난 해 선택',
                        ),
                        const SizedBox(height: 12),
                        PhoneField(
                          controller: _phoneController,
                          validator: _validatePhone,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  AuthButton(
                    loading: _loading,
                    onPressed: _submit,
                    label: '아이디 찾기',
                    color: AppColors.accent,
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
