import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/models/weather.dart';

void main() {
  group('Weather Tests', () {
    test('Serialization/Deserialization', () {
      final weather = Weather(
        condition: 'Rain',
        recommendIndoor: true,
      );
      final json = weather.toJson();
      final deserialized = Weather.fromJson(json);
      expect(deserialized.condition, 'Rain');
      expect(deserialized.recommendIndoor, true);
    });
  });
}