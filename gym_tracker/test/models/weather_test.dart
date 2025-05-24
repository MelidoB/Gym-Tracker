// test/models/weather_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/models/weather.dart';
import 'dart:convert';

void main() {
  group('Weather Tests', () {
    test('Serialization and deserialization', () {
      final weather = Weather(condition: 'Rain', recommendIndoor: true);
      final json = weather.toJson();
      final decoded = Weather.fromJson(json);

      expect(decoded.condition, weather.condition);
      expect(decoded.recommendIndoor, weather.recommendIndoor);
    });

    test('Handles null JSON values', () {
      final decoded = Weather.fromJson({});

      expect(decoded.condition, 'Sunny');
      expect(decoded.recommendIndoor, false);
    });
  });
}