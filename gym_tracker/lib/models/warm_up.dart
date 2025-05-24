// lib/models/warm_up.dart
class WarmUp {
  final String name;
  final String duration;
  final String workoutType;

  WarmUp({
    this.name = '',
    this.duration = '',
    this.workoutType = '',
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'duration': duration,
        'workoutType': workoutType,
      };

  factory WarmUp.fromJson(Map<String, dynamic> json) => WarmUp(
        name: json['name'] ?? '',
        duration: json['duration'] ?? '',
        workoutType: json['workoutType'] ?? '',
      );

  static WarmUp suggestForWorkoutType(String workoutType) {
    switch (workoutType) {
      case 'Legs':
        return WarmUp(name: 'Hip Openers', duration: '3 min', workoutType: 'Legs');
      case 'Upper':
        return WarmUp(name: 'Arm Circles', duration: '2 min', workoutType: 'Upper');
      case 'Cardio':
        return WarmUp(name: 'Jumping Jacks', duration: '2 min', workoutType: 'Cardio');
      default:
        return WarmUp(name: 'General Stretch', duration: '2 min', workoutType: 'General');
    }
  }
}