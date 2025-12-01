// 기본 Flutter 위젯 테스트입니다.
//
// 위젯과 상호작용하려면 `flutter_test` 패키지의 `WidgetTester`를 사용하세요.
// 예: 탭/스크롤 제스처 전송, 위젯 트리에서 자식 위젯 찾기, 텍스트 읽기,
// 위젯 속성 값 검증 등을 수행할 수 있습니다.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // 앱을 빌드하고 프레임을 트리거합니다.
    await tester.pumpWidget(const MyApp());

    // 카운터가 0에서 시작하는지 검증합니다.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // '+' 아이콘을 탭하고 프레임을 트리거합니다.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // 카운터가 증가했는지 검증합니다.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
