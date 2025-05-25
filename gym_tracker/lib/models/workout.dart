import 'dart:convert';

class Workout {
  final String name;
  final String dayOfWeek;
  final String time;
  final String type;
  final int postWorkoutEnergy;
  final int reps;
  final double weight;

  Workout({
    required this.name,
    required this.dayOfWeek,
    required this.time,
    required this.type,
    this.postWorkoutEnergy = 0,
    this.reps = 0,
    this.weight = 0.0,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'dayOfWeek': dayOfWeek,
        'time': time,
        'type': type,
        'postWorkoutEnergy': postWorkoutEnergy,
        'reps': reps,
        'weight': weight,
      };

  factory Workout.fromJson(Map<String, dynamic> json) => Workout(
        name: json['name'] as String? ?? '',
        dayOfWeek: json['dayOfWeek'] as String? ?? '',
        time: json['time'] as String? ?? '',
        type: json['type'] as String? ?? '',
        postWorkoutEnergy: json['postWorkoutEnergy'] as int? ?? 0,
        reps: json['reps'] as int? ?? 0,
        weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      );
}