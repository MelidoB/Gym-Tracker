import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/screens/smart_dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/models/pre_workout.dart';
import 'package:gym_tracker/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  group('smart_dashboard_screen Widget Tests', () {
    late LocalStorageService localStorageService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      localStorageService = LocalStorageService();
      // Initialize mock workout data
      await localStorageService.initializeMockData();
    });

    testWidgets('Renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<LocalStorageService>.value(
            value: localStorageService,
            child: const smart_dashboard_screen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Smart Dashboard'), findsOneWidget);
      expect(find.textContaining('Tuesday 17:00 → Leg Day?'), findsOneWidget);
      expect(find.text('Rain → Indoor Routine'), findsOneWidget);
      expect(find.text('Prepped? (Gym Bag)'), findsOneWidget);
      expect(find.byType(Slider), findsOneWidget);
      expect(find.text('AI Warm-Up'), findsOneWidget);
    });

    testWidgets('Handles pre-workout input', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<LocalStorageService>.value(
            value: localStorageService,
            child: const smart_dashboard_screen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check gym bag
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Select energy level
      await tester.tap(find.text('3'));
      await tester.pump();

      // Adjust water intake
      await tester.drag(find.byType(Slider), const Offset(100, 0));
      await tester.pump();

      final preWorkout = await localStorageService.getPreWorkout();
      expect(preWorkout.gymBagPrepped, true);
      expect(preWorkout.energyLevel, 3);
      expect(preWorkout.waterIntake, greaterThan(500)); // Exact value depends on slider
    });

    testWidgets('Displays warm-up suggestion', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<LocalStorageService>.value(
            value: localStorageService,
            child: const smart_dashboard_screen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Suggested: Hip Openers for 3 min'), findsOneWidget);
    });
  });
}