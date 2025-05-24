import 'dart:convert';

class PostWorkoutRecovery {
  final String workoutId;
  final int sorenessLevel;
  final int postWorkoutEnergy;
  final String recoveryNotes;

  PostWorkoutRecovery({
    required this.workoutId,
    required this.sorenessLevel,
    required this.postWorkoutEnergy,
    required this.recoveryNotes,
  });

  Map<String, dynamic> toJson() => {
        'workoutId': workoutId,
        'sorenessLevel': sorenessLevel,
        'postWorkoutEnergy': postWorkoutEnergy,
        'recoveryNotes': recoveryNotes,
      };

  factory PostWorkoutRecovery.fromJson(Map<String, dynamic> json) => PostWorkoutRecovery(
        workoutId: json['workoutId'] as String? ?? '',
        sorenessLevel: json['sorenessLevel'] as int? ?? 0,
        postWorkoutEnergy: json['postWorkoutEnergy'] as int? ?? 0,
        recoveryNotes: json['recoveryNotes'] as String? ?? '',
      );
}