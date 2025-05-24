// test/models/warm_up_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/models/warm_up.dart';
import 'dart:convert';

void main() {
  group('WarmUp Tests', () {
    test('Serialization and deserialization', () {
      final warmUp = WarmUp(name: 'Hip Openers', duration: '3 min', workoutType: 'Legs');
      final json = warmUp.toJson();
      final decoded = WarmUp.fromJson(json);

      expect(decoded.name, warmUp.name);
      expect(decoded.duration, warmUp.duration);
      expect(decoded.workoutType, warmUp.workoutType);
    });

    test('Handles null JSON values', () {
      final decoded = WarmUp.fromJson({});

      expect(decoded.name, '');
      expect(decoded.duration, '');
      expect(decoded.workoutType, '');
    });

    test('suggestForWorkoutType returns correct suggestion', () {
      expect(WarmUp.suggestForWorkoutType('Legs').name, 'Hip Openers');
      expect(WarmUp.suggestForWorkoutType('Upper').name, 'Arm Circles');
      expect(WarmUp.suggestForWorkoutType('Cardio').name, 'Jumping Jacks');
      expect(WarmUp.suggestForWorkoutType('Unknown').name, 'General Stretch');
    });
  });
}