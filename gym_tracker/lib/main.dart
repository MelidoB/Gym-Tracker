// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker/screens/smart_dashboard_screen.dart';
import 'package:gym_tracker/services/local_storage_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<LocalStorageService>(
      create: (_) => LocalStorageService(),
      child: MaterialApp(
        title: 'Gym Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const smart_dashboard_screen(),
      ),
    );
  }
}