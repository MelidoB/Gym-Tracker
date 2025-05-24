// lib/screens/smart_dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker/models/pre_workout.dart';
import 'package:gym_tracker/models/warm_up.dart';
import 'package:gym_tracker/models/weather.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/screens/settings_screen.dart';
import 'package:gym_tracker/services/local_storage_service.dart';
import 'package:gym_tracker/widgets/reusable_widget.dart';

class smart_dashboard_screen extends StatefulWidget {
  const smart_dashboard_screen({super.key});

  @override
  _SmartDashboardScreenState createState() => _SmartDashboardScreenState();
}

class _SmartDashboardScreenState extends State<smart_dashboard_screen> {
  PreWorkout? _preWorkout;
  List<Workout> _workoutHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final localStorage = Provider.of<LocalStorageService>(context, listen: false);
    final preWorkout = await localStorage.getPreWorkout();
    final workoutHistory = await localStorage.getWorkoutHistory();
    setState(() {
      _preWorkout = preWorkout;
      _workoutHistory = workoutHistory;
      _isLoading = false;
    });
  }

  Future<void> _savePreWorkout(PreWorkout preWorkout) async {
    final localStorage = Provider.of<LocalStorageService>(context, listen: false);
    await localStorage.savePreWorkout(preWorkout);
    setState(() {
      _preWorkout = preWorkout;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final weather = Weather(condition: 'Rain', recommendIndoor: true);
    final suggestedWarmUp = WarmUp.suggestForWorkoutType(
        _workoutHistory.isNotEmpty ? _workoutHistory.first.type : 'General');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReusableWidget(
              title: 'Pre-Workout Checklist',
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('Gym Bag Prepped:'),
                      Checkbox(
                        value: _preWorkout!.gymBagPrepped,
                        onChanged: (value) {
                          _savePreWorkout(_preWorkout!.copyWith(gymBagPrepped: value ?? false));
                        },
                      ),
                    ],
                  ),
                  const Text('Energy Level:'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [1, 2, 3, 4, 5].map((level) {
                      return ElevatedButton(
                        onPressed: () {
                          _savePreWorkout(_preWorkout!.copyWith(energyLevel: level));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _preWorkout!.energyLevel == level
                              ? Colors.blue
                              : Colors.grey,
                        ),
                        child: Text('$level'),
                      );
                    }).toList(),
                  ),
                  Slider(
                    value: _preWorkout!.waterIntake,
                    min: 0,
                    max: 2000,
                    divisions: 20,
                    label: '${_preWorkout!.waterIntake.round()} ml',
                    onChanged: (value) {
                      _savePreWorkout(_preWorkout!.copyWith(waterIntake: value));
                    },
                  ),
                  Text('Water Intake: ${_preWorkout!.waterIntake.round()} ml'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ReusableWidget(
              title: 'Workout History',
              child: _workoutHistory.isEmpty
                  ? const Text('No workouts recorded.')
                  : Column(
                      children: _workoutHistory.map((workout) {
                        return Text(
                            '${workout.dayOfWeek} ${workout.time} → ${workout.name}?');
                      }).toList(),
                    ),
            ),
            const SizedBox(height: 16),
            ReusableWidget(
              title: 'Weather Recommendation',
              child: Text('${weather.condition} → ${weather.recommendIndoor ? 'Indoor' : 'Outdoor'} Routine'),
            ),
            const SizedBox(height: 16),
            ReusableWidget(
              title: 'Suggested Warm-Up',
              child: Text('Suggested: ${suggestedWarmUp.name} for ${suggestedWarmUp.duration}'),
            ),
          ],
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
  }) {
    return PreWorkout(
      gymBagPrepped: gymBagPrepped ?? this.gymBagPrepped,
      energyLevel: energyLevel ?? this.energyLevel,
      waterIntake: waterIntake ?? this.waterIntake,
    );
  }
}