import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('홈'),
        actions: [
          IconButton(
            onPressed: () {
              // 로그아웃: 로그인 화면으로 되돌림
              Navigator.of(context).pushReplacementNamed('/');
            },
            icon: const Icon(Icons.logout),
            tooltip: '로그아웃',
          ),
        ],
      ),
      body: const Center(
        child: Text('로그인 성공! 환영합니다.', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
