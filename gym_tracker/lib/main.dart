import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/settings_screen.dart';
import 'services/local_storage_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<LocalStorageService>(
          create: (_) => LocalStorageService(),
        ),
      ],
      child: MaterialApp(
        title: 'Gym Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SettingsScreen(),
      ),
    ),
  );
}
