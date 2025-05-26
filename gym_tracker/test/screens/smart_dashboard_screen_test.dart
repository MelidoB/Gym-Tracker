import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker/models/pre_workout.dart';
import 'package:gym_tracker/models/user_preferences.dart';
import 'package:gym_tracker/models/warm_up.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/screens/settings_screen.dart';
import 'package:gym_tracker/screens/smart_dashboard_screen.dart';
import 'package:gym_tracker/screens/warmup_screen.dart';
import 'package:gym_tracker/services/local_storage_service.dart';
import '../mocks.mocks.dart';

void main() {
  group('SmartDashboardScreen Widget Tests', () {
    late MockLocalStorageService mockLocalStorageService;

    setUp(() {
      mockLocalStorageService = MockLocalStorageService();

      when(mockLocalStorageService.getPreWorkout()).thenAnswer((_) async =>
          PreWorkout(gymBagPrepped: false, energyLevel: 1, waterIntake: 500));

      when(mockLocalStorageService.savePreWorkout(any)).thenAnswer((_) async => {});

      when(mockLocalStorageService.getWorkoutHistory()).thenAnswer((_) async => [
            Workout(
              name: 'Leg Day',
              dayOfWeek: 'Tuesday',
              time: '17:00',
              type: 'Legs',
            ),
          ]);

      when(mockLocalStorageService.getUserPreferences()).thenAnswer((_) async =>
          UserPreferences(name: 'Test User', useKg: false, preferredWorkoutType: 'General'));
    });

    testWidgets('Renders correctly', (WidgetTester tester) async {
  await tester.pumpWidget(
    Provider<LocalStorageService>(
      create: (_) => mockLocalStorageService,
      child: MaterialApp(
        home: const SmartDashboardScreen(),
        routes: {
          '/settings': (context) => const SettingsScreen(),
        },
      ),
    ),
  );
  await tester.pumpAndSettle();

  expect(find.text('Smart Dashboard'), findsOneWidget);
  expect(find.text('Tuesday 17:00 • Legs • Water: 1000ml'), findsOneWidget); // Match mock data
  expect(find.text('Weather Advice'), findsOneWidget);
  expect(find.text('Recommended Warmup'), findsOneWidget);
});

    testWidgets('Tapping gym bag checkbox saves pre-workout', (WidgetTester tester) async {
  await tester.pumpWidget(
    Provider<LocalStorageService>(
      create: (_) => mockLocalStorageService,
      child: MaterialApp(
        home: const SmartDashboardScreen(),
        routes: {
          '/settings': (context) => const SettingsScreen(),
        },
      ),
    ),
  );
  await tester.pumpAndSettle();

  final checkbox = find.byType(Checkbox);
  expect(checkbox, findsOneWidget); // Ensure checkbox is present
  await tester.tap(checkbox);
  await tester.pump();

  verify(mockLocalStorageService.savePreWorkout(any)).called(1);
});

    testWidgets('Selecting energy level saves pre-workout', (WidgetTester tester) async {
      await tester.pumpWidget(
        Provider<LocalStorageService>(
          create: (_) => mockLocalStorageService,
          child: MaterialApp(
            home: const SmartDashboardScreen(),
            routes: {
              '/settings': (context) => const SettingsScreen(),
            },
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.text('3'));
      await tester.pump();

      verify(mockLocalStorageService.savePreWorkout(any)).called(1);
    });

    testWidgets('Adjusting water intake slider saves pre-workout', (WidgetTester tester) async {
  await tester.pumpWidget(
    Provider<LocalStorageService>(
      create: (_) => mockLocalStorageService,
      child: MaterialApp(
        home: const SmartDashboardScreen(),
        routes: {
          '/settings': (context) => const SettingsScreen(),
        },
      ),
    ),
  );
  await tester.pumpAndSettle();

  final slider = find.byType(Slider);
  expect(slider, findsOneWidget); // Ensure slider is present

  final sliderCenter = tester.getCenter(slider);
  await tester.dragFrom(sliderCenter, const Offset(50.0, 0.0)); // Simulate drag
  await tester.pumpAndSettle();

  verify(mockLocalStorageService.savePreWorkout(any)).called(1); // Verify savePreWorkout is called
});

    testWidgets('Navigates to SettingsScreen on settings icon tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        Provider<LocalStorageService>(
          create: (_) => mockLocalStorageService,
          child: MaterialApp(
            home: const SmartDashboardScreen(),
            routes: {
              '/settings': (context) => const SettingsScreen(),
            },
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('Handles pre-workout input', (WidgetTester tester) async {
  await tester.pumpWidget(
    Provider<LocalStorageService>(
      create: (_) => mockLocalStorageService,
      child: MaterialApp(
        home: const SmartDashboardScreen(),
        routes: {
          '/settings': (context) => const SettingsScreen(),
        },
      ),
    ),
  );
  await tester.pumpAndSettle();

  final checkbox = find.byType(Checkbox);
  expect(checkbox, findsOneWidget); // Ensure checkbox exists
  await tester.tap(checkbox);
  await tester.pump();

  await tester.tap(find.text('3')); // Energy level
  await tester.pump();

  final slider = find.byType(Slider);
  final sliderCenter = tester.getCenter(slider);
  await tester.dragFrom(sliderCenter, const Offset(50.0, 0.0));
  await tester.pumpAndSettle();

  verify(mockLocalStorageService.savePreWorkout(any)).called(3); // 3 interactions
});

    testWidgets('Displays warm-up suggestion', (WidgetTester tester) async {
      await tester.pumpWidget(
        Provider<LocalStorageService>(
          create: (_) => mockLocalStorageService,
          child: MaterialApp(
            home: const SmartDashboardScreen(),
            routes: {
              '/settings': (context) => const SettingsScreen(),
            },
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Lower Body Dynamic Warmup'), findsOneWidget);
    });

    testWidgets('Navigates to WarmupScreen when suggestion is tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        Provider<LocalStorageService>(
          create: (_) => mockLocalStorageService,
          child: MaterialApp(
            home: const SmartDashboardScreen(),
            routes: {
              '/warmup': (context) => WarmupScreen(
                    warmUp: WarmUp.suggestForWorkoutType('Legs'),
                  ),
            },
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.text('Lower Body Dynamic Warmup'));
      await tester.pumpAndSettle();

      expect(find.byType(WarmupScreen), findsOneWidget);
    });
  });
}