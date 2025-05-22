import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/models/pre_workout.dart';
import 'package:gym_tracker/models/user_preferences.dart';
import 'package:gym_tracker/services/local_storage_service.dart';
import 'dart:convert';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalStorageService Tests', () {
    late LocalStorageService localStorageService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      localStorageService = LocalStorageService();
    });

    test('Save and retrieve Workout', () async {
      final workout = Workout(
        name: 'Test Workout',
        dayOfWeek: 'Monday',
        time: '18:00',
        type: 'Legs',
      );
      await localStorageService.saveWorkout(workout);
      final workouts = await localStorageService.getWorkoutHistory();
      expect(workouts.length, 1);
      expect(workouts.first.name, 'Test Workout');
    });

    test('Save and retrieve PreWorkout', () async {
      final preWorkout = PreWorkout(
        gymBagPrepped: true,
        energyLevel: 3,
        waterIntake: 750,
      );
      await localStorageService.savePreWorkout(preWorkout);
      final retrieved = await localStorageService.getPreWorkout();
      expect(retrieved.gymBagPrepped, true);
      expect(retrieved.energyLevel, 3);
      expect(retrieved.waterIntake, 750);
    });

    test('Save and retrieve UserPreferences', () async {
      final prefs = UserPreferences(
        name: 'Test User',
        useKg: true,
        preferredWorkoutType: 'Cardio',
      );
      await localStorageService.saveUserPreferences(prefs);
      final retrieved = await localStorageService.getUserPreferences();
      expect(retrieved.name, 'Test User');
      expect(retrieved.useKg, true);
      expect(retrieved.preferredWorkoutType, 'Cardio');
    });
  });
}