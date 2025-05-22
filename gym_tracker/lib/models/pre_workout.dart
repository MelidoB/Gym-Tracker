class PreWorkout {
  bool gymBagPrepped;
  int energyLevel;
  int waterIntake;

  PreWorkout({
    this.gymBagPrepped = false,
    this.energyLevel = 1,
    this.waterIntake = 500,
  });

  Map<String, dynamic> toJson() {
    return {
      'gymBagPrepped': gymBagPrepped,
      'energyLevel': energyLevel,
      'waterIntake': waterIntake,
    };
  }

  factory PreWorkout.fromJson(Map<String, dynamic> json) {
    return PreWorkout(
      gymBagPrepped: json['gymBagPrepped'] ?? false,
      energyLevel: json['energyLevel'] ?? 1,
      waterIntake: json['waterIntake'] ?? 500,
    );
  }
}