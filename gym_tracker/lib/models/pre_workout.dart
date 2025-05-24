import 'dart:convert';

class PreWorkout {
  final bool gymBagPrepped;
  final int energyLevel;
  final double waterIntake;

  PreWorkout({
    required this.gymBagPrepped,
    required this.energyLevel,
    required this.waterIntake,
  });

  Map<String, dynamic> toJson() => {
        'gymBagPrepped': gymBagPrepped,
        'energyLevel': energyLevel,
        'waterIntake': waterIntake,
      };

  factory PreWorkout.fromJson(Map<String, dynamic> json) => PreWorkout(
        gymBagPrepped: json['gymBagPrepped'] as bool? ?? false,
        energyLevel: json['energyLevel'] as int? ?? 1,
        waterIntake: (json['waterIntake'] as num?)?.toDouble() ?? 500,
      );
}