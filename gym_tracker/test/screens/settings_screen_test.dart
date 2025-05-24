// test/screens/smart_dashboard_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker/models/pre_workout.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/screens/smart_dashboard_screen.dart';
import 'package:gym_tracker/services/local_storage_service.dart';
import '../mocks.mocks.dart';

void main() {
  group('SmartDashboardScreen Widget Tests', () {
    late MockLocalStorageService mockLocalStorageService;

    setUp(() {
      mockLocalStorageService = MockLocalStorageService();

      // Mock getPreWorkout
      when(mockLocalStorageService.getPreWorkout()).thenAnswer((_) async =>
          PreWorkout(gymBagPrepped: false, energyLevel: 1, waterIntake: 500));

      // Mock savePreWorkout
      when(mockLocalStorageService.savePreWorkout(any)).thenAnswer((_) async => {});

      // Mock getWorkoutHistory
      when(mockLocalStorageService.getWorkoutHistory()).thenAnswer((_) async => [
            Workout(
              name: 'Leg Day',
              dayOfWeek: 'Tuesday',
              time: '17:00',
              type: 'Legs',
            ),
          ]);
    });

    testWidgets('SmartDashboardScreen displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        Provider<LocalStorageService>(
          create: (_) => mockLocalStorageService,
          child: const MaterialApp(home: smart_dashboard_screen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Smart Dashboard'), findsOneWidget);
      expect(find.textContaining('Tuesday 17:00 → Leg Day?'), findsOneWidget);
      expect(find.text('Rain → Indoor Routine'), findsOneWidget);
      expect(find.text('Suggested: Hip Openers for 3 min'), findsOneWidget);
    });

    testWidgets('Tapping gym bag checkbox saves pre-workout', (WidgetTester tester) async {
      await tester.pumpWidget(
        Provider<LocalStorageService>(
          create: (_) => mockLocalStorageService,
          child: const MaterialApp(home: smart_dashboard_screen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      verify(mockLocalStorageService.savePreWorkout(any)).called(1);
    });

    testWidgets('Selecting energy level saves pre-workout', (WidgetTester tester) async {
      await tester.pumpWidget(
        Provider<LocalStorageService>(
          create: (_) => mockLocalStorageService,
          child: const MaterialApp(home: smart_dashboard_screen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('3'));
      await tester.pump();

      verify(mockLocalStorageService.savePreWorkout(any)).called(1);
    });

    testWidgets('Adjusting water intake slider saves pre-workout', (WidgetTester tester) async {
      await tester.pumpWidget(
        Provider<LocalStorageService>(
          create: (_) => mockLocalStorageService,
          child: const MaterialApp(home: smart_dashboard_screen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.drag(find.byType(Slider), const Offset(100, 0));
      await tester.pump();

      verify(mockLocalStorageService.savePreWorkout(any)).called(1);
    });

    testWidgets('Navigates to SettingsScreen on settings icon tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        Provider<LocalStorageService>(
          create: (_) => mockLocalStorageService,
          child: const MaterialApp(home: smart_dashboard_screen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
    });
  });
}