// lib/services/local_storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_tracker/models/pre_workout.dart';
import 'package:gym_tracker/models/user_preferences.dart';
import 'package:gym_tracker/models/workout.dart';

class LocalStorageService {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // For testing: Set SharedPreferences instance
  void setPrefsForTesting(SharedPreferences prefs) {
    _prefs = Future.value(prefs);
  }

  Future<void> savePreWorkout(PreWorkout preWorkout) async {
    final prefs = await _prefs;
    await prefs.setString('preWorkout', jsonEncode(preWorkout.toJson()));
  }

  Future<PreWorkout> getPreWorkout() async {
    final prefs = await _prefs;
    final jsonString = prefs.getString('preWorkout');
    if (jsonString == null) {
      return PreWorkout();
    }
    return PreWorkout.fromJson(jsonDecode(jsonString));
  }

  Future<void> saveUserPreferences(UserPreferences preferences) async {
    final prefs = await _prefs;
    await prefs.setString('userPreferences', jsonEncode(preferences.toJson()));
  }

  Future<UserPreferences> getUserPreferences() async {
    final prefs = await _prefs;
    final jsonString = prefs.getString('userPreferences');
    if (jsonString == null) {
      return UserPreferences();
    }
    return UserPreferences.fromJson(jsonDecode(jsonString));
  }

  Future<void> saveWorkout(Workout workout) async {
    final prefs = await _prefs;
    final workouts = await getWorkoutHistory();
    workouts.add(workout);
    final jsonList = workouts.map((w) => jsonEncode(w.toJson())).toList();
    await prefs.setStringList('workouts', jsonList);
  }

  Future<List<Workout>> getWorkoutHistory() async {
    final prefs = await _prefs;
    final jsonList = prefs.getStringList('workouts') ?? [];
    return jsonList.map((jsonString) => Workout.fromJson(jsonDecode(jsonString))).toList();
  }

  Future<void> initializeMockData() async {
    final prefs = await _prefs;
    final workouts = prefs.getStringList('workouts');
    if (workouts == null || workouts.isEmpty) {
      final mockWorkouts = [
        Workout(name: 'Leg Day', dayOfWeek: 'Tuesday', time: '17:00', type: 'Legs'),
        Workout(name: 'Upper Body', dayOfWeek: 'Thursday', time: '18:00', type: 'Upper'),
      ];
      final jsonList = mockWorkouts.map((w) => jsonEncode(w.toJson())).toList();
      await prefs.setStringList('workouts', jsonList);
    }
  }
}