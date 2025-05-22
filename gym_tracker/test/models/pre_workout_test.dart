import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/models/pre_workout.dart';

void main() {
  group('PreWorkout Tests', () {
    test('Serialization/Deserialization', () {
      final preWorkout = PreWorkout(
        gymBagPrepped: true,
        energyLevel: 3,
        waterIntake: 750,
      );
      final json = preWorkout.toJson();
      final deserialized = PreWorkout.fromJson(json);
      expect(deserialized.gymBagPrepped, true);
      expect(deserialized.energyLevel, 3);
      expect(deserialized.waterIntake, 750);
    });
  });
}