import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/models/warm_up.dart';

void main() {
  group('WarmUp Tests', () {
    test('suggestForWorkoutType returns correct suggestion', () {
      expect(WarmUp.suggestForWorkoutType('Legs').name, 
          'Lower Body Dynamic Warmup');
      expect(WarmUp.suggestForWorkoutType('Upper').name, 
          'Upper Body Mobility Routine');
      expect(WarmUp.suggestForWorkoutType('Cardio').name, 
          'Cardio Warmup');
      expect(WarmUp.suggestForWorkoutType('Unknown').name, 
          'General Full Body Warmup');
    });
  });
}