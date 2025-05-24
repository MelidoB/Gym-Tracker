import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker/models/post_workout_recovery.dart';
import 'package:gym_tracker/models/pre_workout.dart';
import 'package:gym_tracker/models/user_preferences.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/screens/history_screen.dart';
import 'package:gym_tracker/services/local_storage_service.dart';
import '../mocks.mocks.dart';

void main() {
  group('HistoryScreen Widget Tests', () {
    late MockLocalStorageService mockLocalStorageService;

    setUp(() {
      mockLocalStorageService = MockLocalStorageService();

      when(mockLocalStorageService.getWorkoutHistory()).thenAnswer((_) async => [
            Workout(
              name: 'Chest Day',
              dayOfWeek: 'Monday',
              time: '18:00',
              type: 'Upper',
              postWorkoutEnergy: 3,
            ),
          ]);

      when(mockLocalStorageService.getSoreness('abc123')).thenAnswer((_) async =>
          PostWorkoutRecovery(
            workoutId: 'abc123',
            sorenessLevel: 4,
            postWorkoutEnergy: 3,
            recoveryNotes: 'Moderate soreness in quads',
          ));

      when(mockLocalStorageService.getUserPreferences()).thenAnswer((_) async =>
          UserPreferences(name: 'Test User', useKg: false, preferredWorkoutType: 'General'));

      when(mockLocalStorageService.getPreWorkout()).thenAnswer((_) async =>
          PreWorkout(gymBagPrepped: false, energyLevel: 1, waterIntake: 500));
    });

    testWidgets('Displays workout and soreness data correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        Provider<LocalStorageService>(
          create: (_) => mockLocalStorageService,
          child: const MaterialApp(home: HistoryScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Workout History'), findsAtLeastNWidgets(1));
      expect(find.textContaining('Monday 18:00 → Chest Day'), findsOneWidget);
      expect(find.textContaining('Soreness: 4'), findsOneWidget);
      expect(find.textContaining('Post-Workout Energy: 3'), findsOneWidget);
      expect(find.textContaining('Notes: Moderate soreness in quads'), findsOneWidget);
    });

    testWidgets('Handles empty workout history', (WidgetTester tester) async {
      when(mockLocalStorageService.getWorkoutHistory()).thenAnswer((_) async => []);

      await tester.pumpWidget(
        Provider<LocalStorageService>(
          create: (_) => mockLocalStorageService,
          child: const MaterialApp(home: HistoryScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Workout History'), findsAtLeastNWidgets(1));
      expect(find.text('No workouts recorded.'), findsOneWidget);
    });
  });
}