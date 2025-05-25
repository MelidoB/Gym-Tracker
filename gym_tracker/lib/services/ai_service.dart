import 'package:gym_tracker/models/workout.dart';

class AIService {
  static Map<String, double> suggestNextWeights({
    required List<Workout> workoutHistory,
    required Map<String, double> lastWeights,
  }) {
    final suggestions = <String, double>{};
    final latestWorkouts = _getLatestWorkouts(workoutHistory);

    lastWeights.forEach((exercise, currentWeight) {
      final latest = latestWorkouts[exercise];
      suggestions[exercise] = _calculateNewWeight(latest, currentWeight);
    });

    return suggestions;
  }

  static Map<String, Workout> _getLatestWorkouts(List<Workout> history) {
    final Map<String, Workout> latest = {};
    for (final workout in history.reversed) {
      latest.putIfAbsent(workout.name, () => workout);
    }
    return latest;
  }

  static double _calculateNewWeight(Workout? workout, double currentWeight) {
    if (workout == null) return currentWeight;

    if (workout.reps >= 12) return currentWeight * 1.10;
    if (workout.reps <= 5) return currentWeight * 0.95;
    return currentWeight;
  }
}