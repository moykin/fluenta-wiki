import 'package:fluenta/core/layout/adaptive_shell.dart';
import 'package:fluenta/core/layout/destinations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _shell({AppDestination current = AppDestination.library}) {
  return MaterialApp(
    home: AdaptiveShell(
      currentDestination: current,
      onDestinationSelected: (_) {},
      child: const SizedBox.shrink(),
    ),
  );
}

void main() {
  group('Каркас приложения', () {
    testWidgets('на телефоне навигация внизу', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_shell());

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
    });

    testWidgets('на планшете и шире навигация сбоку', (tester) async {
      tester.view.physicalSize = const Size(834, 1112);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_shell());

      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
    });

    testWidgets('в нижнем таббаре ровно пять вкладок, как в макете', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_shell());

      expect(find.byType(NavigationDestination), findsNWidgets(5));
    });

    testWidgets('раздел вне таббара не подсвечивает чужую вкладку', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      // Карьера в таббар не входит — виджет не должен упасть на indexOf == -1.
      await tester.pumpWidget(_shell(current: AppDestination.career));

      expect(tester.takeException(), isNull);
      expect(find.byType(NavigationBar), findsOneWidget);
    });
  });
}
