// lib/models/pre_workout.dart
class PreWorkout {
  final bool gymBagPrepped;
  final int energyLevel;
  final double waterIntake;

  PreWorkout({
    this.gymBagPrepped = false,
    this.energyLevel = 1,
    this.waterIntake = 500,
  });

  Map<String, dynamic> toJson() => {
        'gymBagPrepped': gymBagPrepped,
        'energyLevel': energyLevel,
        'waterIntake': waterIntake,
      };

  factory PreWorkout.fromJson(Map<String, dynamic> json) => PreWorkout(
        gymBagPrepped: json['gymBagPrepped'] ?? false,
        energyLevel: json['energyLevel'] ?? 1,
        waterIntake: (json['waterIntake'] ?? 500).toDouble(),
      );
}