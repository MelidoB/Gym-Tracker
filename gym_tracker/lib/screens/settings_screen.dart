import 'package:flutter/material.dart';
import 'package:gym_tracker/models/user_preferences.dart';
import 'package:gym_tracker/services/local_storage_service.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late LocalStorageService _localStorageService;
  UserPreferences _userPreferences = UserPreferences();
  late TextEditingController _nameController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localStorageService = Provider.of<LocalStorageService>(context);
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    final prefs = await _localStorageService.getUserPreferences();
    setState(() {
      _userPreferences = prefs;
      _nameController = TextEditingController(text: _userPreferences.name);
    });
  }

  Future<void> _saveUseKg(bool value) async {
    _userPreferences.useKg = value;
    await _localStorageService.saveUserPreferences(_userPreferences); // Changed from setUserPreferences
    setState(() {});
  }

  Future<void> _saveName(String value) async {
    _userPreferences.name = value;
    await _localStorageService.saveUserPreferences(_userPreferences); // Changed from setUserPreferences
    setState(() {});
  }

  Future<void> _saveWorkoutType(String value) async {
    _userPreferences.preferredWorkoutType = value;
    await _localStorageService.saveUserPreferences(_userPreferences); // Changed from setUserPreferences
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                _saveName(value);
              },
            ),
            Row(
              children: [
                const Text('Use Kilograms'),
                Checkbox(
                  value: _userPreferences.useKg,
                  onChanged: (bool? newValue) {
                    if (newValue != null) {
                      _saveUseKg(newValue);
                    }
                  },
                ),
              ],
            ),
            DropdownButton<String>(
              value: _userPreferences.preferredWorkoutType,
              items: ['General', 'Legs', 'Upper', 'Cardio'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  _saveWorkoutType(newValue);
                }
              },
            ),
            Text('Use Kilograms: ${_userPreferences.useKg ? 'Yes' : 'No'}'),
            Text('Preferred Workout: ${_userPreferences.preferredWorkoutType}'),
          ],
        ),
      ),
    );
  }
}