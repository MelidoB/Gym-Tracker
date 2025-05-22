class UserPreferences {
  String? name;
  bool useKg;
  String preferredWorkoutType;

  UserPreferences({
    this.name = '',
    this.useKg = false,
    this.preferredWorkoutType = 'General',
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'useKg': useKg,
      'preferredWorkoutType': preferredWorkoutType,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      name: json['name'] ?? '',
      useKg: json['useKg'] ?? false,
      preferredWorkoutType: json['preferredWorkoutType'] ?? 'General',
    );
  }
}