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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _localStorageService = Provider.of<LocalStorageService>(context);
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    final name = await _localStorageService.getPreferences('name') as String?;
    final useKg = await _localStorageService.getPreferences('useKg') as bool?;

    setState(() {
      _userPreferences = UserPreferences(
        name: name ?? '',
        useKg: useKg ?? false,
      );
    });
  }

  Future<void> _saveUseKg(bool value) async {
    await _localStorageService.setPreferences('useKg', value);
    setState(() {
      _userPreferences.useKg = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Name: ${_userPreferences.name == '' ? 'None' : _userPreferences.name}'),
            Row(
              children: [
                Checkbox(
                  value: _userPreferences.useKg,
                  onChanged: (bool? newValue) {
                    if (newValue != null) {
                      _saveUseKg(newValue);
                    }
                  },
                ),
                Text('Use Kilograms'),
              ],
            ),
            Text('Use Kilograms: ${_userPreferences.useKg ? 'Yes' : 'No'}'),
          ],
        ),
      ),
    );
  }
}
