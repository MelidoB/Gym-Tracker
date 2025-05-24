// test/models/pre_workout_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/models/pre_workout.dart';
import 'dart:convert';

void main() {
  group('PreWorkout Tests', () {
    test('Serialization and deserialization', () {
      final preWorkout = PreWorkout(gymBagPrepped: true, energyLevel: 3, waterIntake: 1000);
      final json = preWorkout.toJson();
      final decoded = PreWorkout.fromJson(json);

      expect(decoded.gymBagPrepped, preWorkout.gymBagPrepped);
      expect(decoded.energyLevel, preWorkout.energyLevel);
      expect(decoded.waterIntake, preWorkout.waterIntake);
    });

    test('Handles null JSON values', () {
      final decoded = PreWorkout.fromJson({});

      expect(decoded.gymBagPrepped, false);
      expect(decoded.energyLevel, 1);
      expect(decoded.waterIntake, 500);
    });
  });
}