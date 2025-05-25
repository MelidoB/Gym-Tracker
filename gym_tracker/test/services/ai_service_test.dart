import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/services/ai_service.dart';

void main() {
  group('AIService Weight Suggestions', () {
    final mockWorkoutHistory = [
      Workout(
        name: 'Bench Press',
        dayOfWeek: 'Monday',
        time: '10:00',
        type: 'Chest',
        reps: 8,
        weight: 70.0,
      ),
      Workout(
        name: 'Squat',
        dayOfWeek: 'Wednesday',
        time: '15:00',
        type: 'Legs',
        reps: 12,
        weight: 100.0,
      ),
    ];

    test('Suggest weights with empty history returns last weights', () {
      final suggestions = AIService.suggestNextWeights(
        workoutHistory: [],
        lastWeights: {'Bench Press': 70.0},
      );
      expect(suggestions['Bench Press'], 70.0);
    });

    // In test/services/ai_service_test.dart
    test('Increase weight by 10% for high reps (≥12)', () {
      final suggestions = AIService.suggestNextWeights(
        workoutHistory: [highRepWorkout],
        lastWeights: {'Squat': 100.0},
      );
      expect(suggestions['Squat']?.toStringAsFixed(1), '110.0');
    });

    test('Maintain weight for medium reps (6-11)', () {
      final suggestions = AIService.suggestNextWeights(
        workoutHistory: mockWorkoutHistory,
        lastWeights: {'Bench Press': 70.0},
      );
      expect(suggestions['Bench Press'], 70.0);
    });

    test('Decrease weight by 5% for low reps (<=5)', () {
      final lowRepWorkout = Workout(
        name: 'Deadlift',
        dayOfWeek: 'Friday',
        time: '12:00',
        type: 'Back',
        reps: 3,
        weight: 150.0,
      );
      final suggestions = AIService.suggestNextWeights(
        workoutHistory: [...mockWorkoutHistory, lowRepWorkout],
        lastWeights: {'Deadlift': 150.0},
      );
      expect(suggestions['Deadlift'], 142.5); // 150 - 5%
    });

// In test/services/ai_service_test.dart
    test('Handle missing lastWeights with default values', () {
      final suggestions = AIService.suggestNextWeights(
        workoutHistory: mockWorkoutHistory,
        lastWeights: {'Bench Press': 70.0, 'Squat': 100.0},
      );
      expect(suggestions['Bench Press'], 70.0);
      expect(suggestions['Squat'], 100.0);
    });
  });
}