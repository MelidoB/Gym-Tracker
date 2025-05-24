// test/models/workout_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/models/workout.dart';
import 'dart:convert';

void main() {
  group('Workout Tests', () {
    test('Serialization and deserialization', () {
      final workout = Workout(name: 'Leg Day', dayOfWeek: 'Tuesday', time: '17:00', type: 'Legs');
      final json = workout.toJson();
      final decoded = Workout.fromJson(json);

      expect(decoded.name, workout.name);
      expect(decoded.dayOfWeek, workout.dayOfWeek);
      expect(decoded.time, workout.time);
      expect(decoded.type, workout.type);
    });

    test('Handles null JSON values', () {
      final decoded = Workout.fromJson({});

      expect(decoded.name, '');
      expect(decoded.dayOfWeek, '');
      expect(decoded.time, '');
      expect(decoded.type, '');
    });
  });
}