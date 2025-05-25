import 'dart:convert';

class UserPreferences {
  final String name;
  final bool useKg;
  final String preferredWorkoutType;
  final Map<String, double> lastWeights;

  UserPreferences({
    required this.name,
    required this.useKg,
    required this.preferredWorkoutType,
    this.lastWeights = const {},
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'useKg': useKg,
        'preferredWorkoutType': preferredWorkoutType,
        'lastWeights': lastWeights,
      };

  factory UserPreferences.fromJson(Map<String, dynamic> json) => UserPreferences(
        name: json['name'] as String? ?? '',
        useKg: json['useKg'] as bool? ?? false,
        preferredWorkoutType: json['preferredWorkoutType'] as String? ?? 'General',
        lastWeights: (json['lastWeights'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(k, (v as num).toDouble()),
            ) ??
            {},
      );

  UserPreferences copyWith({
    String? name,
    bool? useKg,
    String? preferredWorkoutType,
    Map<String, double>? lastWeights,
  }) {
    return UserPreferences(
      name: name ?? this.name,
      useKg: useKg ?? this.useKg,
      preferredWorkoutType: preferredWorkoutType ?? this.preferredWorkoutType,
      lastWeights: lastWeights ?? this.lastWeights,
    );
  }
} 