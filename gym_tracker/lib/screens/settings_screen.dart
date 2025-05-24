// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker/models/user_preferences.dart';
import 'package:gym_tracker/services/local_storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _nameController;
  UserPreferences? _userPreferences;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final localStorage = Provider.of<LocalStorageService>(context, listen: false);
    final prefs = await localStorage.getUserPreferences();
    setState(() {
      _userPreferences = prefs;
      _nameController.text = prefs.name;
      _isLoading = false;
    });
  }

  Future<void> _savePreferences(UserPreferences prefs) async {
    final localStorage = Provider.of<LocalStorageService>(context, listen: false);
    await localStorage.saveUserPreferences(prefs);
    setState(() {
      _userPreferences = prefs;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                _savePreferences(_userPreferences!.copyWith(name: value));
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Use Kilograms:'),
                Checkbox(
                  value: _userPreferences!.useKg,
                  onChanged: (value) {
                    _savePreferences(_userPreferences!.copyWith(useKg: value ?? false));
                  },
                ),
                Text(_userPreferences!.useKg ? 'Yes' : 'No'),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _userPreferences!.preferredWorkoutType,
              items: ['General', 'Cardio', 'Strength', 'Flexibility']
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  _savePreferences(_userPreferences!.copyWith(preferredWorkoutType: value));
                }
              },
            ),
            Text('Preferred Workout: ${_userPreferences!.preferredWorkoutType}'),
          ],
        ),
      ),
    );
  }
}

extension on UserPreferences {
  UserPreferences copyWith({
    String? name,
    bool? useKg,
    String? preferredWorkoutType,
  }) {
    return UserPreferences(
      name: name ?? this.name,
      useKg: useKg ?? this.useKg,
      preferredWorkoutType: preferredWorkoutType ?? this.preferredWorkoutType,
    );
  }
}