// lib/models/user_preferences.dart
class UserPreferences {
  final String name;
  final bool useKg;
  final String preferredWorkoutType;

  UserPreferences({
    this.name = '',
    this.useKg = false,
    this.preferredWorkoutType = 'General',
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'useKg': useKg,
        'preferredWorkoutType': preferredWorkoutType,
      };

  factory UserPreferences.fromJson(Map<String, dynamic> json) => UserPreferences(
        name: json['name'] ?? '',
        useKg: json['useKg'] ?? false,
        preferredWorkoutType: json['preferredWorkoutType'] ?? 'General',
      );
}