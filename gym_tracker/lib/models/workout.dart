import 'package:intl/intl.dart';

class Workout {
  String name;
  String dayOfWeek;
  String time;
  String type;

  Workout({
    required this.name,
    required this.dayOfWeek,
    required this.time,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dayOfWeek': dayOfWeek,
      'time': time,
      'type': type,
    };
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      name: json['name'] ?? '',
      dayOfWeek: json['dayOfWeek'] ?? '',
      time: json['time'] ?? '',
      type: json['type'] ?? '',
    );
  }

  // Helper to check if workout matches current day/time
  bool matchesCurrentTime() {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE HH:mm');
    final currentDay = DateFormat('EEEE').format(now);
    final currentTime = DateFormat('HH:mm').format(now);
    return dayOfWeek == currentDay && time == currentTime;
  }
}