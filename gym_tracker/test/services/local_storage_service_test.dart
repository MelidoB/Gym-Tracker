import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_tracker/models/post_workout_recovery.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/services/local_storage_service.dart';
import 'dart:convert';

import 'local_storage_service_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LocalStorageService Tests', () {
    late LocalStorageService localStorageService;
    late MockSharedPreferences mockPrefs;

    setUp(() async {
      mockPrefs = MockSharedPreferences();
      when(mockPrefs.getString(any)).thenReturn(null);
      when(mockPrefs.getStringList(any)).thenReturn(null);
      when(mockPrefs.setString(any, any)).thenAnswer((_) async => true);
      when(mockPrefs.setStringList(any, any)).thenAnswer((_) async => true);

      localStorageService = LocalStorageService(prefs: mockPrefs);
    });

    test('Saves soreness data correctly', () async {
      final soreness = PostWorkoutRecovery(
        workoutId: 'abc123',
        sorenessLevel: 4,
        postWorkoutEnergy: 3,
        recoveryNotes: 'Moderate soreness in quads',
      );
      final jsonString = jsonEncode(soreness.toJson());

      await localStorageService.saveSoreness(soreness);

      verify(mockPrefs.setString('soreness_abc123', jsonString)).called(1);
    });

    test('Retrieves soreness data correctly', () async {
      final soreness = PostWorkoutRecovery(
        workoutId: 'abc123',
        sorenessLevel: 4,
        postWorkoutEnergy: 3,
        recoveryNotes: 'Moderate soreness in quads',
      );
      final jsonString = jsonEncode(soreness.toJson());
      when(mockPrefs.getString('soreness_abc123')).thenReturn(jsonString);

      final result = await localStorageService.getSoreness('abc123');

      expect(result.workoutId, 'abc123');
      expect(result.sorenessLevel, 4);
      expect(result.postWorkoutEnergy, 3);
      expect(result.recoveryNotes, 'Moderate soreness in quads');
    });

    test('Returns default soreness when no data exists', () async {
      final result = await localStorageService.getSoreness('abc123');

      expect(result.workoutId, 'abc123');
      expect(result.sorenessLevel, 0);
      expect(result.postWorkoutEnergy, 0);
      expect(result.recoveryNotes, '');
    });

    test('Saves workout with postWorkoutEnergy correctly', () async {
      final workout = Workout(
        name: 'Chest Day',
        dayOfWeek: 'Monday',
        time: '18:00',
        type: 'Upper',
        postWorkoutEnergy: 3,
      );
      final jsonList = [jsonEncode(workout.toJson())];
      when(mockPrefs.getStringList('workouts')).thenReturn([]);

      await localStorageService.saveWorkout(workout);

      verify(mockPrefs.setStringList('workouts', jsonList)).called(1);
    });

    test('Retrieves workout history with postWorkoutEnergy', () async {
      final workout = Workout(
        name: 'Chest Day',
        dayOfWeek: 'Monday',
        time: '18:00',
        type: 'Upper',
        postWorkoutEnergy: 3,
      );
      final jsonList = [jsonEncode(workout.toJson())];
      when(mockPrefs.getStringList('workouts')).thenReturn(jsonList);

      final result = await localStorageService.getWorkoutHistory();

      expect(result.length, 1);
      expect(result[0].name, 'Chest Day');
      expect(result[0].postWorkoutEnergy, 3);
    });

    test('initializeMockData includes postWorkoutEnergy', () async {
      final mockWorkouts = [
        Workout(
          name: 'Leg Day',
          dayOfWeek: 'Tuesday',
          time: '17:00',
          type: 'Legs',
          postWorkoutEnergy: 2,
        ),
        Workout(
          name: 'Upper Body',
          dayOfWeek: 'Thursday',
          time: '18:00',
          type: 'Upper',
          postWorkoutEnergy: 3,
        ),
      ];
      final jsonList = mockWorkouts.map((w) => jsonEncode(w.toJson())).toList();
      when(mockPrefs.getStringList('workouts')).thenReturn(null);

      await localStorageService.initializeMockData();

      verify(mockPrefs.setStringList('workouts', jsonList)).called(1);
    });
  });
}