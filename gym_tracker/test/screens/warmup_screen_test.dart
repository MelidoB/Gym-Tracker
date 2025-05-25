import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/models/warm_up.dart';
import 'package:gym_tracker/screens/warmup_screen.dart';

void main() {
  group('WarmupScreen Tests', () {
    // In test/screens/warmup_screen_test.dart
testWidgets('Displays correct warm-up details', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: WarmupScreen(
        warmUp: WarmUp(
          name: 'Dynamic Stretching',
          duration: '5 min',
          workoutType: 'Full Body',
        ),
      ),
    ),
  );

  expect(find.text('Warmup Routine'), findsOneWidget);
  expect(find.text('Dynamic Stretching'), findsOneWidget);
});

    testWidgets('Shows default values for empty warm-up', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: WarmupScreen(warmUp: WarmUp()),
        ),
      );

      expect(find.text('Warmup Recommendation'), findsOneWidget);
      expect(find.text('Name: Not Specified'), findsOneWidget);
    });
  });
}