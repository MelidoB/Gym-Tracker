import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/models/warm_up.dart';

void main() {
  group('WarmUp Tests', () {
    test('Suggestion Logic', () {
      final legsWarmUp = WarmUp.suggestForWorkoutType('Legs');
      expect(legsWarmUp.name, 'Hip Openers');
      expect(legsWarmUp.duration, '3 min');
      expect(legsWarmUp.workoutType, 'Legs');

      final upperWarmUp = WarmUp.suggestForWorkoutType('Upper');
      expect(upperWarmUp.name, 'Arm Circles');
      expect(upperWarmUp.duration, '2 min');
      expect(upperWarmUp.workoutType, 'Upper');

      final defaultWarmUp = WarmUp.suggestForWorkoutType('Unknown');
      expect(defaultWarmUp.name, 'General Stretch');
      expect(defaultWarmUp.duration, '2 min');
      expect(defaultWarmUp.workoutType, 'General');
    });
  });
}