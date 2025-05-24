// test/models_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/models/pre_workout.dart';
import 'package:gym_tracker/models/user_preferences.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/models/warm_up.dart';
import 'package:gym_tracker/models/weather.dart';
import 'dart:convert';

void main() {
  group('Model Tests', () {
    test('PreWorkout serialization and deserialization', () {
      final preWorkout = PreWorkout(gymBagPrepped: true, energyLevel: 3, waterIntake: 1000);
      final json = preWorkout.toJson();
      final decoded = PreWorkout.fromJson(json);

      expect(decoded.gymBagPrepped, preWorkout.gymBagPrepped);
      expect(decoded.energyLevel, preWorkout.energyLevel);
      expect(decoded.waterIntake, preWorkout.waterIntake);
    });

    test('PreWorkout handles null JSON values', () {
      final decoded = PreWorkout.fromJson({});

      expect(decoded.gymBagPrepped, false);
      expect(decoded.energyLevel, 1);
      expect(decoded.waterIntake, 500);
    });

    test('UserPreferences serialization and deserialization', () {
      final userPrefs = UserPreferences(name: 'Test User', useKg: true, preferredWorkoutType: 'Cardio');
      final json = userPrefs.toJson();
      final decoded = UserPreferences.fromJson(json);

      expect(decoded.name, userPrefs.name);
      expect(decoded.useKg, userPrefs.useKg);
      expect(decoded.preferredWorkoutType, userPrefs.preferredWorkoutType);
    });

    test('UserPreferences handles null JSON values', () {
      final decoded = UserPreferences.fromJson({});

      expect(decoded.name, '');
      expect(decoded.useKg, false);
      expect(decoded.preferredWorkoutType, 'General');
    });

    test('Workout serialization and deserialization', () {
      final workout = Workout(name: 'Leg Day', dayOfWeek: 'Tuesday', time: '17:00', type: 'Legs');
      final json = workout.toJson();
      final decoded = Workout.fromJson(json);

      expect(decoded.name, workout.name);
      expect(decoded.dayOfWeek, workout.dayOfWeek);
      expect(decoded.time, workout.time);
      expect(decoded.type, workout.type);
    });

    test('Workout handles null JSON values', () {
      final decoded = Workout.fromJson({});

      expect(decoded.name, '');
      expect(decoded.dayOfWeek, '');
      expect(decoded.time, '');
      expect(decoded.type, '');
    });

    test('WarmUp serialization and deserialization', () {
      final warmUp = WarmUp(name: 'Hip Openers', duration: '3 min', workoutType: 'Legs');
      final json = warmUp.toJson();
      final decoded = WarmUp.fromJson(json);

      expect(decoded.name, warmUp.name);
      expect(decoded.duration, warmUp.duration);
      expect(decoded.workoutType, warmUp.workoutType);
    });

    test('WarmUp handles null JSON values', () {
      final decoded = WarmUp.fromJson({});

      expect(decoded.name, '');
      expect(decoded.duration, '');
      expect(decoded.workoutType, '');
    });

    test('WarmUp suggestForWorkoutType returns correct suggestion', () {
      expect(WarmUp.suggestForWorkoutType('Legs').name, 'Hip Openers');
      expect(WarmUp.suggestForWorkoutType('Upper').name, 'Arm Circles');
      expect(WarmUp.suggestForWorkoutType('Cardio').name, 'Jumping Jacks');
      expect(WarmUp.suggestForWorkoutType('Unknown').name, 'General Stretch');
    });

    test('Weather serialization and deserialization', () {
      final weather = Weather(condition: 'Rain', recommendIndoor: true);
      final json = weather.toJson();
      final decoded = Weather.fromJson(json);

      expect(decoded.condition, weather.condition);
      expect(decoded.recommendIndoor, weather.recommendIndoor);
    });

    test('Weather handles null JSON values', () {
      final decoded = Weather.fromJson({});

      expect(decoded.condition, 'Sunny');
      expect(decoded.recommendIndoor, false);
    });
  });
}