import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker/models/pre_workout.dart';
import 'package:gym_tracker/models/user_preferences.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/models/warm_up.dart';
import 'package:gym_tracker/screens/smart_dashboard_screen.dart';
import 'package:gym_tracker/screens/warmup_screen.dart';
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
              type: 'Upper', // Fixed: Match type for warmup suggestion
              reps: 8,
              weight: 70.0,
            ),
          ]);

      when(mockStorage.getPreWorkout()).thenAnswer((_) async =>
          PreWorkout(gymBagPrepped: false, energyLevel: 1, waterIntake: 500));
    });

    testWidgets('Displays weight suggestions', (WidgetTester tester) async {
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
      expect(find.text('70.0kg'), findsOneWidget); // Fixed: Use unique text from trailing
    });

    testWidgets('Navigates to WarmupScreen', (WidgetTester tester) async {
      await tester.pumpWidget(
        Provider<LocalStorageService>(
          create: (_) => mockStorage,
          child: MaterialApp(
            home: const SmartDashboardScreen(),
            routes: {
              '/warmup': (_) => WarmupScreen(warmUp: WarmUp.suggestForWorkoutType('Upper')),
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
      
      expect(find.text('Upper Body Mobility Routine'), findsOneWidget); // Verify text exists
      await tester.tap(find.text('Upper Body Mobility Routine')); // Fixed: Match warmup name
      await tester.pumpAndSettle();

      expect(find.byType(WarmupScreen), findsOneWidget);
    });
  });
}