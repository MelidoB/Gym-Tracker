import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/workout.dart';
import '../models/weather.dart';
import '../services/local_storage_service.dart';
import 'settings_screen.dart';
import 'package:intl/intl.dart';

class SmartDashboardScreen extends StatefulWidget {
  const SmartDashboardScreen({Key? key}) : super(key: key);

  @override
  State<SmartDashboardScreen> createState() => _SmartDashboardScreenState();
}

class _SmartDashboardScreenState extends State<SmartDashboardScreen> {
  late LocalStorageService _localStorageService;
  Workout? _suggestedWorkout;
  Weather _weather = Weather(condition: 'Rain', recommendIndoor: true); // Mock

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localStorageService = Provider.of<LocalStorageService>(context);
    _loadSuggestedWorkout();
  }

  Future<void> _loadSuggestedWorkout() async {
    final workouts = await _localStorageService.getWorkoutHistory();
    final now = DateTime.now();
    final currentDay = DateFormat('EEEE').format(now);
    // Suggest workout based on last 3 workouts for the current day
    final recentWorkouts = workouts
        .where((w) => w.dayOfWeek == currentDay)
        .take(3)
        .toList();
    setState(() {
      _suggestedWorkout = recentWorkouts.isNotEmpty ? recentWorkouts.first : null;
    });
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
          ],
        ),
      ),
    );
  }
}