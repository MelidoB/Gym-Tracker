import 'dart:convert';

class Workout {
  final String name;
  final String dayOfWeek;
  final String time;
  final String type;

  Workout({
    required this.name,
    required this.dayOfWeek,
    required this.time,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'dayOfWeek': dayOfWeek,
        'time': time,
        'type': type,
      };

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
        name: json['name'] as String? ?? '',
        dayOfWeek: json['dayOfWeek'] as String? ?? '',
        time: json['time'] as String? ?? '',
        type: json['type'] as String? ?? '',
      );
}