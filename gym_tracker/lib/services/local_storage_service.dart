import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_tracker/models/pre_workout.dart';
import 'package:gym_tracker/models/user_preferences.dart';
import 'package:gym_tracker/models/workout.dart';

class LocalStorageService {
  SharedPreferences? _prefs;

  LocalStorageService({SharedPreferences? prefs}) {
    if (prefs != null) {
      _prefs = prefs;
    }
  }

  Future<void> _initPrefs() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  void setPrefsForTesting(SharedPreferences prefs) {
    _prefs = prefs;
  }

  Future<void> savePreWorkout(PreWorkout preWorkout) async {
    await _initPrefs();
    await _prefs!.setString('preWorkout', jsonEncode(preWorkout.toJson()));
  }

  Future<PreWorkout> getPreWorkout() async {
    await _initPrefs();
    final jsonString = _prefs!.getString('preWorkout');
    if (jsonString == null) {
      return PreWorkout(gymBagPrepped: false, energyLevel: 1, waterIntake: 500);
    }
    return PreWorkout.fromJson(jsonDecode(jsonString));
  }

  Future<void> saveUserPreferences(UserPreferences prefs) async {
    await _initPrefs();
    await _prefs!.setString('userPreferences', jsonEncode(prefs.toJson()));
  }

  Future<UserPreferences> getUserPreferences() async {
    await _initPrefs();
    final jsonString = _prefs!.getString('userPreferences');
    if (jsonString == null) {
      return UserPreferences(name: '', useKg: false, preferredWorkoutType: 'General');
    }
    return UserPreferences.fromJson(jsonDecode(jsonString));
  }

  Future<void> saveWorkout(Workout workout) async {
    await _initPrefs();
    final workouts = await getWorkoutHistory();
    workouts.add(workout);
    final jsonList = workouts.map((w) => jsonEncode(w.toJson())).toList();
    await _prefs!.setStringList('workouts', jsonList);
  }

  Future<List<Workout>> getWorkoutHistory() async {
    await _initPrefs();
    final jsonList = _prefs!.getStringList('workouts') ?? [];
    return jsonList.map((json) => Workout.fromJson(jsonDecode(json))).toList();
  }

  Future<void> initializeMockData() async {
    await _initPrefs();
    final workouts = _prefs!.getStringList('workouts');
    if (workouts == null || workouts.isEmpty) {
      final mockWorkouts = [
        Workout(name: 'Leg Day', dayOfWeek: 'Tuesday', time: '17:00', type: 'Legs'),
        Workout(name: 'Upper Body', dayOfWeek: 'Thursday', time: '18:00', type: 'Upper'),
      ];
      final jsonList = mockWorkouts.map((w) => jsonEncode(w.toJson())).toList();
      await _prefs!.setStringList('workouts', jsonList);
    }
  }
}