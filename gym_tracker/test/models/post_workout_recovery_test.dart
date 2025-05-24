import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/models/post_workout_recovery.dart';
import 'dart:convert';

void main() {
  group('PostWorkoutRecovery Tests', () {
    test('Serializes and deserializes correctly', () {
      final recovery = PostWorkoutRecovery(
        workoutId: 'abc123',
        sorenessLevel: 4,
        postWorkoutEnergy: 3,
        recoveryNotes: 'Moderate soreness in quads',
      );
      final json = recovery.toJson();
      final decoded = PostWorkoutRecovery.fromJson(json);

      expect(decoded.workoutId, 'abc123');
      expect(decoded.sorenessLevel, 4);
      expect(decoded.postWorkoutEnergy, 3);
      expect(decoded.recoveryNotes, 'Moderate soreness in quads');
    });

    test('Handles missing JSON fields with defaults', () {
      final decoded = PostWorkoutRecovery.fromJson({});

      expect(decoded.workoutId, '');
      expect(decoded.sorenessLevel, 0);
      expect(decoded.postWorkoutEnergy, 0);
      expect(decoded.recoveryNotes, '');
    });

    test('Handles partial JSON data', () {
      final json = {
        'workoutId': 'xyz789',
        'sorenessLevel': 2,
      };
      final decoded = PostWorkoutRecovery.fromJson(json);

      expect(decoded.workoutId, 'xyz789');
      expect(decoded.sorenessLevel, 2);
      expect(decoded.postWorkoutEnergy, 0);
      expect(decoded.recoveryNotes, '');
    });
  });
}