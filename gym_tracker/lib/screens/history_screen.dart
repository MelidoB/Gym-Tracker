import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/models/post_workout_recovery.dart';
import 'package:gym_tracker/services/local_storage_service.dart';
import 'package:gym_tracker/widgets/reusable_widget.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Workout> _workoutHistory = [];
  Map<String, PostWorkoutRecovery> _sorenessData = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final localStorage = Provider.of<LocalStorageService>(context, listen: false);
    final workouts = await localStorage.getWorkoutHistory();
    final sorenessMap = <String, PostWorkoutRecovery>{};
    for (var workout in workouts) {
      try {
        final soreness = await localStorage.getSoreness(workout.name);
        sorenessMap[workout.name] = soreness;
      } catch (e) {
        sorenessMap[workout.name] = PostWorkoutRecovery(
          workoutId: workout.name,
          sorenessLevel: 0,
          postWorkoutEnergy: workout.postWorkoutEnergy,
          recoveryNotes: '',
        );
      }
    }
    setState(() {
      _workoutHistory = workouts;
      _sorenessData = sorenessMap;
      _isLoading = false;
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
      appBar: AppBar(
        title: const Text('Workout History'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReusableWidget(
              title: 'Workout History',
              child: _workoutHistory.isEmpty
                  ? const Text('No workouts recorded.')
                  : Column(
                      children: _workoutHistory.map((workout) {
                        final soreness = _sorenessData[workout.name] ??
                            PostWorkoutRecovery(
                              workoutId: workout.name,
                              sorenessLevel: 0,
                              postWorkoutEnergy: workout.postWorkoutEnergy,
                              recoveryNotes: 'No recovery data',
                            );
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${workout.dayOfWeek} ${workout.time} → ${workout.name}'),
                            Text('Soreness: ${soreness.sorenessLevel}'),
                            Text('Post-Workout Energy: ${soreness.postWorkoutEnergy}'),
                            Text('Notes: ${soreness.recoveryNotes.isEmpty ? 'None' : soreness.recoveryNotes}'),
                            const SizedBox(height: 8),
                          ],
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}