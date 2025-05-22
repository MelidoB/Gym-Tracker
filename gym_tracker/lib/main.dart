import 'package:flutter/material.dart';
import 'package:gym_tracker/screens/SmartDashboardScreen.dart';
import 'package:provider/provider.dart';

import 'services/local_storage_service.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<LocalStorageService>(
          create: (_) => LocalStorageService()..initializeMockData(),
        ),
      ],
      child: MaterialApp(
        title: 'Gym Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SmartDashboardScreen(),
      ),
    ),
  );
}