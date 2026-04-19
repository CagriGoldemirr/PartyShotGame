// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:party_shot_game/main.dart';
import 'package:party_shot_game/features/setup/logic/setup_provider.dart';

void main() {
  testWidgets('PartyShotApp loads the start screen', (WidgetTester tester) async {
    // Build our app with the required provider and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider<SetupProvider>(
        create: (_) => SetupProvider(),
        child: const PartyShotApp(),
      ),
    );

    // Verify the start screen is displayed.
    expect(find.text('DRINK\nROULETTE'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('OYNA'), findsOneWidget);
  });
}
