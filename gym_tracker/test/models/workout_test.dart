import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:intl/intl.dart';

void main() {
  group('Workout Tests', () {
    test('Serialization/Deserialization', () {
      final workout = Workout(
        name: 'Leg Day',
        dayOfWeek: 'Tuesday',
        time: '17:00',
        type: 'Legs',
      );
      final json = workout.toJson();
      final deserialized = Workout.fromJson(json);
      expect(deserialized.name, 'Leg Day');
      expect(deserialized.dayOfWeek, 'Tuesday');
      expect(deserialized.time, '17:00');
      expect(deserialized.type, 'Legs');
    });

    test('Matches Current Time', () {
      final now = DateTime.now();
      final day = DateFormat('EEEE').format(now);
      final time = DateFormat('HH:mm').format(now);
      final workout = Workout(
        name: 'Test',
        dayOfWeek: day,
        time: time,
        type: 'General',
      );
      expect(workout.matchesCurrentTime(), true);
    });
  });
}