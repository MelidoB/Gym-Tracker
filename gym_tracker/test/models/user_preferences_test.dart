import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/models/user_preferences.dart';

void main() {
  group('UserPreferences Tests', () {
    test('Serialization', () {
      final prefs = UserPreferences(
        name: 'John',
        useKg: true,
        preferredWorkoutType: 'Legs',
      );
      final json = prefs.toJson();
      expect(json['name'], 'John');
      expect(json['useKg'], true);
      expect(json['preferredWorkoutType'], 'Legs');
    });

    test('Deserialization', () {
      final json = {
        'name': 'Jane',
        'useKg': false,
        'preferredWorkoutType': 'Cardio',
      };
      final prefs = UserPreferences.fromJson(json);
      expect(prefs.name, 'Jane');
      expect(prefs.useKg, false);
      expect(prefs.preferredWorkoutType, 'Cardio');
    });
  });
}