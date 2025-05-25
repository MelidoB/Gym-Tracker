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
    switch (workoutType.toLowerCase()) {
      case 'legs':
        return WarmUp(
          name: 'Lower Body Dynamic Warmup',
          duration: '5-7 minutes',
          workoutType: 'Legs',
        );
      case 'upper':
        return WarmUp(
          name: 'Upper Body Mobility Routine',
          duration: '5 minutes',
          workoutType: 'Upper',
        );
      case 'cardio':
        return WarmUp(
          name: 'Cardio Warmup',
          duration: '3-5 minutes',
          workoutType: 'Cardio',
        );
      default:
        return WarmUp(
          name: 'General Full Body Warmup',
          duration: '5 minutes',
          workoutType: 'General',
        );
    }
  }
}