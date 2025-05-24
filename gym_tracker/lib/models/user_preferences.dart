import 'dart:convert';

class UserPreferences {
  final String name;
  final bool useKg;
  final String preferredWorkoutType;

  UserPreferences({
    required this.name,
    required this.useKg,
    required this.preferredWorkoutType,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'useKg': useKg,
        'preferredWorkoutType': preferredWorkoutType,
      };

  factory UserPreferences.fromJson(Map<String, dynamic> json) => UserPreferences(
        name: json['name'] as String? ?? '',
        useKg: json['useKg'] as bool? ?? false,
        preferredWorkoutType: json['preferredWorkoutType'] as String? ?? 'General',
      );
}