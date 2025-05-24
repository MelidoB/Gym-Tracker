// test/models/user_preferences_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/models/user_preferences.dart';
import 'dart:convert';

void main() {
  group('UserPreferences Tests', () {
    test('Serialization and deserialization', () {
      final userPrefs = UserPreferences(name: 'Test User', useKg: true, preferredWorkoutType: 'Cardio');
      final json = userPrefs.toJson();
      final decoded = UserPreferences.fromJson(json);

      expect(decoded.name, userPrefs.name);
      expect(decoded.useKg, userPrefs.useKg);
      expect(decoded.preferredWorkoutType, userPrefs.preferredWorkoutType);
    });

    test('Handles null JSON values', () {
      final decoded = UserPreferences.fromJson({});

      expect(decoded.name, '');
      expect(decoded.useKg, false);
      expect(decoded.preferredWorkoutType, 'General');
    });
  });
}