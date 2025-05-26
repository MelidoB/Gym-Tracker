// test/screens/prep_check_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker/models/pre_workout.dart';
import 'package:gym_tracker/screens/prep_check_screen.dart';
import 'package:gym_tracker/services/local_storage_service.dart';
import '../mocks.mocks.dart';

void main() {
  group('PrepCheckScreen Widget Tests', () {
    late MockLocalStorageService mockLocalStorageService;

    setUp(() {
      mockLocalStorageService = MockLocalStorageService();

      when(mockLocalStorageService.getPreWorkout()).thenAnswer((_) async =>
          PreWorkout(
            gymBagPrepped: false,
            energyLevel: 1,
            waterIntake: 500,
            workoutClothesReady: false,
            waterBottleFilled: false,
          ));

      when(mockLocalStorageService.savePreWorkout(any)).thenAnswer((_) async => {});
    });

    testWidgets('Displays checklist correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        Provider<LocalStorageService>(
          create: (_) => mockLocalStorageService,
          child: const MaterialApp(home: PrepCheckScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Pre-Workout Checklist'), findsOneWidget);
      expect(find.text('Gym Bag Prepped'), findsOneWidget);
      expect(find.text('Workout Clothes Ready'), findsOneWidget);
      expect(find.text('Water Bottle Filled'), findsOneWidget);
    });

    testWidgets('Toggling checklist items saves pre-workout', (WidgetTester tester) async {
  await tester.pumpWidget(
    Provider<LocalStorageService>(
      create: (_) => mockLocalStorageService,
      child: const MaterialApp(home: PrepCheckScreen()),
    ),
  );
  await tester.pumpAndSettle();

  await tester.tap(find.text('Gym Bag Prepped'));
  await tester.pump();
  verify(mockLocalStorageService.savePreWorkout(any)).called(1);

  await tester.tap(find.text('Workout Clothes Ready'));
  await tester.pump();
  verify(mockLocalStorageService.savePreWorkout(any)).called(1); // Total 2 calls
});
  });
}