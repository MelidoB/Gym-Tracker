// lib/widgets/water_tracker.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/services/local_storage_service.dart';
import 'package:gym_tracker/widgets/reusable_widget.dart';

class WaterTracker extends StatefulWidget {
  final Workout workout;

  const WaterTracker({super.key, required this.workout});

  @override
  _WaterTrackerState createState() => _WaterTrackerState();
}

class _WaterTrackerState extends State<WaterTracker> {
  late double _waterIntake;

  @override
  void initState() {
    super.initState();
    _waterIntake = widget.workout.waterIntake;
  }

  Future<void> _saveWaterIntake(double value) async {
    final localStorage = context.read<LocalStorageService>();
    final updatedWorkout = widget.workout.copyWith(waterIntake: value);
    await localStorage.saveWorkout(updatedWorkout);
    setState(() {
      _waterIntake = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReusableWidget(
      title: 'Water Intake Tracker',
      child: Column(
        children: [
          Text('${_waterIntake.round()} ml'),
          Slider(
            value: _waterIntake,
            min: 0,
            max: 3000,
            divisions: 6,
            label: '${_waterIntake.round()} ml',
            onChanged: (value) => setState(() {
              _waterIntake = value;
            }),
            onChangeEnd: (value) => _saveWaterIntake(value),
          ),
          ElevatedButton(
            onPressed: () => _saveWaterIntake(_waterIntake + 250),
            child: const Text('Add 250ml'),
          ),
        ],
      ),
    );
  }
}

extension on Workout {
  Workout copyWith({
    String? name,
    String? dayOfWeek,
    String? time,
    String? type,
    int? postWorkoutEnergy,
    int? reps,
    double? weight,
    double? waterIntake,
  }) {
    return Workout(
      name: name ?? this.name,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      time: time ?? this.time,
      type: type ?? this.type,
      postWorkoutEnergy: postWorkoutEnergy ?? this.postWorkoutEnergy,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      waterIntake: waterIntake ?? this.waterIntake,
    );
  }
}