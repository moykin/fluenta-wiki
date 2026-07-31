import 'package:fluenta/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('приложение запускается и открывает Библиотеку', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const FluentaApp());
    await tester.pumpAndSettle();

    // Заголовок стартового раздела.
    expect(find.text('Библиотека'), findsWidgets);
  });

  testWidgets('переход между разделами меняет содержимое', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const FluentaApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Тьютор').last);
    await tester.pumpAndSettle();

    expect(find.textContaining('Пересказ прочитанного вслух'), findsOneWidget);
  });
}
