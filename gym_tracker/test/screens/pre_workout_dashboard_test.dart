import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker/models/user_preferences.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/screens/smart_dashboard_screen.dart';
import 'package:gym_tracker/services/ai_service.dart';
import 'package:gym_tracker/services/local_storage_service.dart';
import '../mocks.mocks.dart';

void main() {
  group('PreWorkoutDashboard Tests', () {
    late MockLocalStorageService mockStorage;

    setUp(() {
      mockStorage = MockLocalStorageService();
      
      when(mockStorage.getUserPreferences()).thenAnswer((_) async =>
          UserPreferences(
            name: 'Test User',
            useKg: true,
            preferredWorkoutType: 'Strength',
            lastWeights: {'Bench Press': 70.0},
          ));

      when(mockStorage.getWorkoutHistory()).thenAnswer((_) async => [
            Workout(
              name: 'Bench Press',
              dayOfWeek: 'Monday',
              time: '10:00',
              type: 'Chest',
              reps: 8,
              weight: 70.0,
            ),
          ]);
    });

    testWidgets('Displays weight suggestions', (tester) async {
      await tester.pumpWidget(
        Provider<LocalStorageService>(
          create: (_) => mockStorage,
          child: const MaterialApp(
            home: SmartDashboardScreen(),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      expect(find.text('Suggested Weights'), findsOneWidget);
      expect(find.textContaining('Bench Press: 70.0 kg'), findsOneWidget);
    });

    testWidgets('Navigates to WarmupScreen', (tester) async {
      await tester.pumpWidget(
        Provider<LocalStorageService>(
          create: (_) => mockStorage,
          child: MaterialApp(
            home: const SmartDashboardScreen(),
            routes: {
              '/warmup': (_) => const WarmupScreen(warmUp: WarmUp()),
            },
          ),
        ),
      );

      await tester.tap(find.text('Start Warmup'));
      await tester.pumpAndSettle();

      expect(find.byType(WarmupScreen), findsOneWidget);
    });
  });
}