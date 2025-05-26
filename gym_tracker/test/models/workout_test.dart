// test/models/workout_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/models/workout.dart';
import 'dart:convert';

void main() {
  group('Workout Tests', () {
    test('Serializes and deserializes with postWorkoutEnergy and waterIntake', () {
      final workout = Workout(
        name: 'Chest Day',
        dayOfWeek: 'Monday',
        time: '18:00',
        type: 'Upper',
        postWorkoutEnergy: 3,
        waterIntake: 1000,
      );
      final json = workout.toJson();
      final decoded = Workout.fromJson(json);

      expect(decoded.name, 'Chest Day');
      expect(decoded.dayOfWeek, 'Monday');
      expect(decoded.time, '18:00');
      expect(decoded.type, 'Upper');
      expect(decoded.postWorkoutEnergy, 3);
      expect(decoded.waterIntake, 1000);
    });

    test('Handles missing JSON fields with defaults', () {
      final decoded = Workout.fromJson({});

      expect(decoded.name, '');
      expect(decoded.dayOfWeek, '');
      expect(decoded.time, '');
      expect(decoded.type, '');
      expect(decoded.postWorkoutEnergy, 0);
      expect(decoded.waterIntake, 0.0);
    });

    test('Handles partial JSON with postWorkoutEnergy and waterIntake', () {
      final json = {
        'name': 'Cardio',
        'postWorkoutEnergy': 4,
        'waterIntake': 750,
      };
      final decoded = Workout.fromJson(json);

      expect(decoded.name, 'Cardio');
      expect(decoded.dayOfWeek, '');
      expect(decoded.time, '');
      expect(decoded.type, '');
      expect(decoded.postWorkoutEnergy, 4);
      expect(decoded.waterIntake, 750);
    });
  });
}