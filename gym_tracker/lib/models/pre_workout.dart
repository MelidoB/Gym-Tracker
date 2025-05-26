class PreWorkout {
  final bool gymBagPrepped;
  final int energyLevel;
  final double waterIntake;
  final bool workoutClothesReady;
  final bool waterBottleFilled;

  PreWorkout({
    required this.gymBagPrepped,
    required this.energyLevel,
    required this.waterIntake,
    this.workoutClothesReady = false,
    this.waterBottleFilled = false,
  });

  Map<String, dynamic> toJson() => {
        'gymBagPrepped': gymBagPrepped,
        'energyLevel': energyLevel,
        'waterIntake': waterIntake,
        'workoutClothesReady': workoutClothesReady,
        'waterBottleFilled': waterBottleFilled,
      };

  factory PreWorkout.fromJson(Map<String, dynamic> json) => PreWorkout(
        gymBagPrepped: json['gymBagPrepped'] as bool? ?? false,
        energyLevel: json['energyLevel'] as int? ?? 1,
        waterIntake: (json['waterIntake'] as num?)?.toDouble() ?? 500,
        workoutClothesReady: json['workoutClothesReady'] as bool? ?? false,
        waterBottleFilled: json['waterBottleFilled'] as bool? ?? false,
      );
}