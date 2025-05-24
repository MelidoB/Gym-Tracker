// test/services/local_storage_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_tracker/models/pre_workout.dart';
import 'package:gym_tracker/models/user_preferences.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/services/local_storage_service.dart';
import 'dart:convert';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('LocalStorageService Tests', () {
    late LocalStorageService localStorageService;
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
      localStorageService = LocalStorageService();
      localStorageService.setPrefsForTesting(mockSharedPreferences);
    });

    test('savePreWorkout stores data correctly', () async {
      final preWorkout = PreWorkout(gymBagPrepped: true, energyLevel: 3, waterIntake: 1000);
      when(mockSharedPreferences.setString('preWorkout', any)).thenAnswer((_) async => true);

      await localStorageService.savePreWorkout(preWorkout);

      verify(mockSharedPreferences.setString('preWorkout', jsonEncode(preWorkout.toJson()))).called(1);
    });

    test('getPreWorkout returns stored data', () async {
      final preWorkout = PreWorkout(gymBagPrepped: true, energyLevel: 3, waterIntake: 1000);
      when(mockSharedPreferences.getString('preWorkout')).thenReturn(jsonEncode(preWorkout.toJson()));

      final result = await localStorageService.getPreWorkout();

      expect(result.gymBagPrepped, preWorkout.gymBagPrepped);
      expect(result.energyLevel, preWorkout.energyLevel);
      expect(result.waterIntake, preWorkout.waterIntake);
    });

    test('getPreWorkout returns default when no data', () async {
      when(mockSharedPreferences.getString('preWorkout')).thenReturn(null);

      final result = await localStorageService.getPreWorkout();

      expect(result.gymBagPrepped, false);
      expect(result.energyLevel, 1);
      expect(result.waterIntake, 500);
    });

    test('saveUserPreferences stores data correctly', () async {
      final userPrefs = UserPreferences(name: 'Test User', useKg: true, preferredWorkoutType: 'Cardio');
      when(mockSharedPreferences.setString('userPreferences', any)).thenAnswer((_) async => true);

      await localStorageService.saveUserPreferences(userPrefs);

      verify(mockSharedPreferences.setString('userPreferences', jsonEncode(userPrefs.toJson()))).called(1);
    });

    test('getUserPreferences returns stored data', () async {
      final userPrefs = UserPreferences(name: 'Test User', useKg: true, preferredWorkoutType: 'Cardio');
      when(mockSharedPreferences.getString('userPreferences')).thenReturn(jsonEncode(userPrefs.toJson()));

      final result = await localStorageService.getUserPreferences();

      expect(result.name, userPrefs.name);
      expect(result.useKg, userPrefs.useKg);
      expect(result.preferredWorkoutType, userPrefs.preferredWorkoutType);
    });

    test('getUserPreferences returns default when no data', () async {
      when(mockSharedPreferences.getString('userPreferences')).thenReturn(null);

      final result = await localStorageService.getUserPreferences();

      expect(result.name, '');
      expect(result.useKg, false);
      expect(result.preferredWorkoutType, 'General');
    });

    test('saveWorkout adds to workout history', () async {
      final workout = Workout(name: 'Leg Day', dayOfWeek: 'Tuesday', time: '17:00', type: 'Legs');
      when(mockSharedPreferences.getStringList('workouts')).thenReturn([]);
      when(mockSharedPreferences.setStringList('workouts', any)).thenAnswer((_) async => true);

      await localStorageService.saveWorkout(workout);

      verify(mockSharedPreferences.setStringList('workouts', [jsonEncode(workout.toJson())])).called(1);
    });

    test('getWorkoutHistory returns stored workouts', () async {
      final workout = Workout(name: 'Leg Day', dayOfWeek: 'Tuesday', time: '17:00', type: 'Legs');
      when(mockSharedPreferences.getStringList('workouts')).thenReturn([jsonEncode(workout.toJson())]);

      final result = await localStorageService.getWorkoutHistory();

      expect(result.length, 1);
      expect(result[0].name, workout.name);
      expect(result[0].dayOfWeek, workout.dayOfWeek);
      expect(result[0].time, workout.time);
      expect(result[0].type, workout.type);
    });

    test('getWorkoutHistory returns empty list when no data', () async {
      when(mockSharedPreferences.getStringList('workouts')).thenReturn([]);

      final result = await localStorageService.getWorkoutHistory();

      expect(result, isEmpty);
    });

    test('initializeMockData sets mock workouts when none exist', () async {
      when(mockSharedPreferences.getStringList('workouts')).thenReturn(null);
      when(mockSharedPreferences.setStringList('workouts', any)).thenAnswer((_) async => true);

      await localStorageService.initializeMockData();

      verify(mockSharedPreferences.setStringList('workouts', any)).called(1);
    });
  });
}