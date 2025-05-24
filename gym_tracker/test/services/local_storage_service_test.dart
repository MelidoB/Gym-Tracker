import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_tracker/models/pre_workout.dart';
import 'package:gym_tracker/models/user_preferences.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/services/local_storage_service.dart';
import 'dart:convert';

import 'local_storage_service_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalStorageService Tests', () {
    late LocalStorageService localStorageService;
    late MockSharedPreferences mockSharedPreferences;

    setUp(() async {
      mockSharedPreferences = MockSharedPreferences();
      // Set default mocks to avoid MissingPluginException
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      when(mockSharedPreferences.getStringList(any)).thenReturn(null);
      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);
      when(mockSharedPreferences.setStringList(any, any)).thenAnswer((_) async => true);

      // Pass mock directly to constructor
      localStorageService = LocalStorageService(prefs: mockSharedPreferences);
    });

    test('savePreWorkout stores data correctly', () async {
      final preWorkout = PreWorkout(gymBagPrepped: true, energyLevel: 3, waterIntake: 1000);
      final jsonString = jsonEncode(preWorkout.toJson());

      await localStorageService.savePreWorkout(preWorkout);

      verify(mockSharedPreferences.setString('preWorkout', jsonString)).called(1);
    });

    test('getPreWorkout returns stored data', () async {
      final preWorkout = PreWorkout(gymBagPrepped: true, energyLevel: 3, waterIntake: 1000);
      final jsonString = jsonEncode(preWorkout.toJson());
      when(mockSharedPreferences.getString('preWorkout')).thenReturn(jsonString);

      final result = await localStorageService.getPreWorkout();

      expect(result.gymBagPrepped, preWorkout.gymBagPrepped);
      expect(result.energyLevel, preWorkout.energyLevel);
      expect(result.waterIntake, preWorkout.waterIntake);
    });

    test('getPreWorkout returns default when no data', () async {
      final result = await localStorageService.getPreWorkout();

      expect(result.gymBagPrepped, false);
      expect(result.energyLevel, 1);
      expect(result.waterIntake, 500);
    });

    test('saveUserPreferences stores data correctly', () async {
      final userPrefs = UserPreferences(name: 'Test User', useKg: true, preferredWorkoutType: 'Cardio');
      final jsonString = jsonEncode(userPrefs.toJson());

      await localStorageService.saveUserPreferences(userPrefs);

      verify(mockSharedPreferences.setString('userPreferences', jsonString)).called(1);
    });

    test('getUserPreferences returns stored data', () async {
      final userPrefs = UserPreferences(name: 'Test User', useKg: true, preferredWorkoutType: 'Cardio');
      final jsonString = jsonEncode(userPrefs.toJson());
      when(mockSharedPreferences.getString('userPreferences')).thenReturn(jsonString);

      final result = await localStorageService.getUserPreferences();

      expect(result.name, userPrefs.name);
      expect(result.useKg, userPrefs.useKg);
      expect(result.preferredWorkoutType, userPrefs.preferredWorkoutType);
    });

    test('getUserPreferences returns default when no data', () async {
      final result = await localStorageService.getUserPreferences();

      expect(result.name, '');
      expect(result.useKg, false);
      expect(result.preferredWorkoutType, 'General');
    });

    test('saveWorkout adds to workout history', () async {
      final workout = Workout(name: 'Leg Day', dayOfWeek: 'Tuesday', time: '17:00', type: 'Legs');
      final jsonList = [jsonEncode(workout.toJson())];
      when(mockSharedPreferences.getStringList('workouts')).thenReturn([]);

      await localStorageService.saveWorkout(workout);

      verify(mockSharedPreferences.setStringList('workouts', jsonList)).called(1);
    });

    test('getWorkoutHistory returns stored workouts', () async {
      final workout = Workout(name: 'Leg Day', dayOfWeek: 'Tuesday', time: '17:00', type: 'Legs');
      final jsonList = [jsonEncode(workout.toJson())];
      when(mockSharedPreferences.getStringList('workouts')).thenReturn(jsonList);

      final result = await localStorageService.getWorkoutHistory();

      expect(result.length, 1);
      expect(result[0].name, workout.name);
      expect(result[0].dayOfWeek, workout.dayOfWeek);
      expect(result[0].time, workout.time);
      expect(result[0].type, workout.type);
    });

    test('getWorkoutHistory returns empty list when no data', () async {
      final result = await localStorageService.getWorkoutHistory();

      expect(result, isEmpty);
    });

    test('initializeMockData sets mock workouts when none exist', () async {
      final mockWorkouts = [
        Workout(name: 'Leg Day', dayOfWeek: 'Tuesday', time: '17:00', type: 'Legs'),
        Workout(name: 'Upper Body', dayOfWeek: 'Thursday', time: '18:00', type: 'Upper'),
      ];
      final jsonList = mockWorkouts.map((w) => jsonEncode(w.toJson())).toList();
      when(mockSharedPreferences.getStringList('workouts')).thenReturn(null);

      await localStorageService.initializeMockData();

      verify(mockSharedPreferences.setStringList('workouts', jsonList)).called(1);
    });
  });
}