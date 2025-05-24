// lib/models/workout.dart
class Workout {
  final String name;
  final String dayOfWeek;
  final String time;
  final String type;

  Workout({
    this.name = '',
    this.dayOfWeek = '',
    this.time = '',
    this.type = '',
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'dayOfWeek': dayOfWeek,
        'time': time,
        'type': type,
      };

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
        name: json['name'] ?? '',
        dayOfWeek: json['dayOfWeek'] ?? '',
        time: json['time'] ?? '',
        type: json['type'] ?? '',
      );
}