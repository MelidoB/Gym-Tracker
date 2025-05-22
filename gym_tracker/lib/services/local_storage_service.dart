import 'package:shared_preferences/shared_preferences.dart';
import '../models/workout.dart';
import '../models/pre_workout.dart';
import '../models/user_preferences.dart';
import 'dart:convert';

class LocalStorageService {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> setPreferences(String key, dynamic value) async {
    final prefs = await _prefs;
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    }
  }

  Future<dynamic> getPreferences(String key) async {
    final prefs = await _prefs;
    return prefs.get(key);
  }

  Future<void> saveWorkout(Workout workout) async {
    final prefs = await _prefs;
    List<String> workouts = prefs.getStringList('workouts') ?? [];
    workouts.add(jsonEncode(workout.toJson()));
    await prefs.setStringList('workouts', workouts);
  }

  Future<List<Workout>> getWorkoutHistory() async {
    final prefs = await _prefs;
    final workouts = prefs.getStringList('workouts') ?? [];
    return workouts.map((w) => Workout.fromJson(jsonDecode(w))).toList();
  }

  Future<void> savePreWorkout(PreWorkout preWorkout) async {
    final prefs = await _prefs;
    await prefs.setString('preWorkout', jsonEncode(preWorkout.toJson()));
  }

  Future<PreWorkout> getPreWorkout() async {
    final prefs = await _prefs;
    final preWorkoutJson = prefs.getString('preWorkout');
    if (preWorkoutJson != null) {
      return PreWorkout.fromJson(jsonDecode(preWorkoutJson));
    }
    return PreWorkout();
  }

  Future<void> saveUserPreferences(UserPreferences prefs) async {
    final sharedPrefs = await _prefs;
    await sharedPrefs.setString('userPreferences', jsonEncode(prefs.toJson()));
  }

  Future<UserPreferences> getUserPreferences() async {
    final prefs = await _prefs;
    final prefsJson = prefs.getString('userPreferences');
    if (prefsJson != null) {
      return UserPreferences.fromJson(jsonDecode(prefsJson));
    }
    return UserPreferences();
  }

  Future<void> clearData() async {
    final prefs = await _prefs;
    await prefs.clear();
  }

  Future<void> initializeMockData() async {
    final prefs = await _prefs;
    if (prefs.getStringList('workouts') == null) {
      final mockWorkouts = [
        Workout(name: 'Leg Day', dayOfWeek: 'Tuesday', time: '17:00', type: 'Legs'),
        Workout(name: 'Upper Body', dayOfWeek: 'Tuesday', time: '17:00', type: 'Upper'),
        Workout(name: 'Cardio', dayOfWeek: 'Tuesday', time: '17:00', type: 'Cardio'),
      ];
      await prefs.setStringList(
        'workouts',
        mockWorkouts.map((w) => jsonEncode(w.toJson())).toList(),
      );
    }
  }

}