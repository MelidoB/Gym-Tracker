import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../models/weather.dart';
import '../models/pre_workout.dart';
import '../models/warm_up.dart';
import '../services/local_storage_service.dart';
import 'settings_screen.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class SmartDashboardScreen extends StatefulWidget {
  const SmartDashboardScreen({Key? key}) : super(key: key);

  @override
  State<SmartDashboardScreen> createState() => _SmartDashboardScreenState();
}

class _SmartDashboardScreenState extends State<SmartDashboardScreen> {
  late LocalStorageService _localStorageService;
  Workout? _suggestedWorkout;
  Weather _weather = Weather(condition: 'Rain', recommendIndoor: true); // Mock
  PreWorkout _preWorkout = PreWorkout();
  WarmUp? _warmUp;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localStorageService = Provider.of<LocalStorageService>(context);
    _loadSuggestedWorkout();
    _loadPreWorkout();
  }

  Future<void> _loadSuggestedWorkout() async {
    final workouts = await _localStorageService.getWorkoutHistory();
    final now = DateTime.now();
    final currentDay = DateFormat('EEEE').format(now);
    final recentWorkouts = workouts
        .where((w) => w.dayOfWeek == currentDay)
        .take(3)
        .toList();
    setState(() {
      _suggestedWorkout = recentWorkouts.isNotEmpty ? recentWorkouts.first : null;
      _warmUp = _suggestedWorkout != null
          ? WarmUp.suggestForWorkoutType(_suggestedWorkout!.type)
          : null;
    });
  }

  Future<void> _loadPreWorkout() async {
    final preWorkout = await _localStorageService.getPreWorkout();
    setState(() {
      _preWorkout = preWorkout;
    });
  }

  Future<void> _savePreWorkout() async {
    await _localStorageService.savePreWorkout(_preWorkout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _suggestedWorkout != null
                  ? '${_suggestedWorkout!.dayOfWeek} ${_suggestedWorkout!.time} → ${_suggestedWorkout!.name}?'
                  : 'No workout suggestion',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              '${_weather.condition} → ${_weather.recommendIndoor ? 'Indoor Routine' : 'Outdoor Routine'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            const Text('One-Tap Prep', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Row(
              children: [
                const Text('Prepped? (Gym Bag)'),
                Checkbox(
                  value: _preWorkout.gymBagPrepped,
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() {
                        _preWorkout.gymBagPrepped = value;
                      });
                      _savePreWorkout();
                    }
                  },
                ),
              ],
            ),
            const Text('Energy Level (1-5):'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) => index + 1).map((level) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _preWorkout.energyLevel = level;
                    });
                    _savePreWorkout();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _preWorkout.energyLevel == level ? Colors.blue : null,
                  ),
                  child: Text('$level'),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text('Water Intake (ml):'),
            Slider(
              value: _preWorkout.waterIntake.toDouble(),
              min: 0,
              max: 2000,
              divisions: 8,
              label: '${_preWorkout.waterIntake} ml',
              onChanged: (double value) {
                setState(() {
                  _preWorkout.waterIntake = value.round();
                });
                _savePreWorkout();
              },
            ),
            Text('Water: ${_preWorkout.waterIntake} ml'),
            const SizedBox(height: 24),
            const Text('AI Warm-Up', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(
              _warmUp != null
                  ? 'Suggested: ${_warmUp!.name} for ${_warmUp!.duration}'
                  : 'No warm-up suggestion',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}