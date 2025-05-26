// lib/screens/prep_check_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker/models/pre_workout.dart';
import 'package:gym_tracker/services/local_storage_service.dart';
import 'package:gym_tracker/widgets/reusable_widget.dart';

class PrepCheckScreen extends StatefulWidget {
  const PrepCheckScreen({super.key});

  @override
  _PrepCheckScreenState createState() => _PrepCheckScreenState();
}

class _PrepCheckScreenState extends State<PrepCheckScreen> {
  PreWorkout? _preWorkout;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreWorkout();
  }

  Future<void> _loadPreWorkout() async {
    final localStorage = context.read<LocalStorageService>();
    final preWorkout = await localStorage.getPreWorkout();
    setState(() {
      _preWorkout = preWorkout;
      _isLoading = false;
    });
  }

  Future<void> _savePreWorkout(PreWorkout updated) async {
    final localStorage = context.read<LocalStorageService>();
    await localStorage.savePreWorkout(updated);
    setState(() {
      _preWorkout = updated;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Pre-Workout Checklist')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReusableWidget(
          title: 'Checklist',
          child: Column(
            children: [
              CheckboxListTile(
                title: const Text('Gym Bag Prepped'),
                value: _preWorkout!.gymBagPrepped,
                onChanged: (value) {
                  _savePreWorkout(
                    _preWorkout!.copyWith(gymBagPrepped: value ?? false),
                  );
                },
              ),
              CheckboxListTile(
                title: const Text('Workout Clothes Ready'),
                value: _preWorkout!.workoutClothesReady ?? false,
                onChanged: (value) {
                  _savePreWorkout(
                    _preWorkout!.copyWith(workoutClothesReady: value ?? false),
                  );
                },
              ),
              CheckboxListTile(
                title: const Text('Water Bottle Filled'),
                value: _preWorkout!.waterBottleFilled ?? false,
                onChanged: (value) {
                  _savePreWorkout(
                    _preWorkout!.copyWith(waterBottleFilled: value ?? false),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on PreWorkout {
  PreWorkout copyWith({
    bool? gymBagPrepped,
    int? energyLevel,
    double? waterIntake,
    bool? workoutClothesReady,
    bool? waterBottleFilled,
  }) {
    return PreWorkout(
      gymBagPrepped: gymBagPrepped ?? this.gymBagPrepped,
      energyLevel: energyLevel ?? this.energyLevel,
      waterIntake: waterIntake ?? this.waterIntake,
      workoutClothesReady: workoutClothesReady ?? this.workoutClothesReady,
      waterBottleFilled: waterBottleFilled ?? this.waterBottleFilled,
    );
  }
}