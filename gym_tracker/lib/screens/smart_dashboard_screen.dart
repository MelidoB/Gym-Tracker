import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker/models/pre_workout.dart';
import 'package:gym_tracker/models/warm_up.dart';
import 'package:gym_tracker/models/weather.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/screens/settings_screen.dart';
import 'package:gym_tracker/screens/warmup_screen.dart';
import 'package:gym_tracker/services/ai_service.dart';
import 'package:gym_tracker/services/local_storage_service.dart';
import 'package:gym_tracker/widgets/reusable_widget.dart';

class SmartDashboardScreen extends StatefulWidget {
  const SmartDashboardScreen({super.key});

  @override
  State<SmartDashboardScreen> createState() => _SmartDashboardScreenState();
}

class _SmartDashboardScreenState extends State<SmartDashboardScreen> {
  PreWorkout? _preWorkout;
  List<Workout> _workoutHistory = [];
  Map<String, double> _weightSuggestions = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    final localStorage = context.read<LocalStorageService>();
    final prefs = await localStorage.getUserPreferences();
    final workouts = await localStorage.getWorkoutHistory();

    setState(() {
      _preWorkout = await localStorage.getPreWorkout();
      _workoutHistory = workouts;
      _weightSuggestions = AIService.suggestNextWeights(
        workoutHistory: workouts,
        lastWeights: prefs.lastWeights,
      );
      _isLoading = false;
    });
  }

  Widget _buildWeightSuggestions() {
    return ReusableWidget(
      title: 'Suggested Weights',
      child: _weightSuggestions.isEmpty
          ? const Text('No suggestions available. Complete a workout first.')
          : Column(
              children: _weightSuggestions.entries.map((entry) {
                final latestWorkout = _workoutHistory.reversed
                    .firstWhere((w) => w.name == entry.key);
                return ListTile(
                  title: Text(entry.key),
                  subtitle: Text(
                    'Last session: ${latestWorkout.reps} reps @ ${latestWorkout.weight}kg',
                  ),
                  trailing: Text(
                    '${entry.value.toStringAsFixed(1)}kg',
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildWarmupRecommendation() {
    final warmUp = WarmUp.suggestForWorkoutType(
      _workoutHistory.isNotEmpty ? _workoutHistory.first.type : 'General');
    
    return ReusableWidget(
      title: 'Recommended Warmup',
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.fitness_center),
            title: Text(warmUp.name),
            subtitle: Text('For ${warmUp.workoutType} workouts'),
            trailing: Text(warmUp.duration),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => WarmupScreen(warmUp: warmUp),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text('Tap to view detailed warmup routine'),
        ],
      ),
    );
  }

  Widget _buildPreWorkoutSection() {
    return ReusableWidget(
      title: 'Pre-Workout Checklist',
      child: Column(
        children: [
          Row(
            children: [
              const Text('Gym Bag Ready:'),
              Checkbox(
                value: _preWorkout?.gymBagPrepped ?? false,
                onChanged: (value) => _savePreWorkout(
                  _preWorkout!.copyWith(gymBagPrepped: value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Energy Level:'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              final level = index + 1;
              return ChoiceChip(
                label: Text('$level'),
                selected: _preWorkout?.energyLevel == level,
                onSelected: (selected) => _savePreWorkout(
                  _preWorkout!.copyWith(energyLevel: level),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          const Text('Water Intake:'),
          Slider(
            value: _preWorkout?.waterIntake ?? 500,
            min: 0,
            max: 2000,
            divisions: 4,
            label: '${(_preWorkout?.waterIntake ?? 500).round()}ml',
            onChanged: (value) => setState(() {
              _preWorkout = _preWorkout?.copyWith(waterIntake: value);
            }),
            onChangeEnd: (value) => _savePreWorkout(
              _preWorkout!.copyWith(waterIntake: value)),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutHistory() {
    return ReusableWidget(
      title: 'Recent Workouts',
      child: _workoutHistory.isEmpty
          ? const Text('No workouts recorded yet.')
          : Column(
              children: _workoutHistory.reversed.take(3).map((workout) {
                return ListTile(
                  title: Text(workout.name),
                  subtitle: Text(
                    '${workout.dayOfWeek} ${workout.time} • ${workout.type}',
                  ),
                  trailing: Text('${workout.weight}kg x ${workout.reps}'),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildWeatherRecommendation() {
    final weather = Weather(condition: 'Sunny', recommendIndoor: false);
    return ReusableWidget(
      title: 'Weather Advice',
      child: Row(
        children: [
          const Icon(Icons.wb_sunny, size: 40),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(weather.condition),
              Text(weather.recommendIndoor 
                  ? 'Recommended: Indoor workout' 
                  : 'Great for outdoor training'),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _savePreWorkout(PreWorkout newPreWorkout) async {
    final localStorage = context.read<LocalStorageService>();
    await localStorage.savePreWorkout(newPreWorkout);
    setState(() => _preWorkout = newPreWorkout);
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
        title: const Text('Smart Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildWeightSuggestions(),
              const SizedBox(height: 20),
              _buildWarmupRecommendation(),
              const SizedBox(height: 20),
              _buildPreWorkoutSection(),
              const SizedBox(height: 20),
              _buildWorkoutHistory(),
              const SizedBox(height: 20),
              _buildWeatherRecommendation(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

extension _PreWorkoutCopyWith on PreWorkout {
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