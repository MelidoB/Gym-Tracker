import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker/models/pre_workout.dart';
import 'package:gym_tracker/models/user_preferences.dart';
import 'package:gym_tracker/screens/settings_screen.dart';
import 'package:gym_tracker/services/local_storage_service.dart';
import '../mocks.mocks.dart';

void main() {
  group('SettingsScreen Widget Tests', () {
    late MockLocalStorageService mockLocalStorageService;

    setUp(() {
      mockLocalStorageService = MockLocalStorageService();

      // Mock getUserPreferences
      when(mockLocalStorageService.getUserPreferences()).thenAnswer((_) async =>
          UserPreferences(name: 'Test User', useKg: false, preferredWorkoutType: 'General'));

      // Mock saveUserPreferences
      when(mockLocalStorageService.saveUserPreferences(any)).thenAnswer((_) async => {});

      // Mock getPreWorkout (for consistency with other tests)
      when(mockLocalStorageService.getPreWorkout()).thenAnswer((_) async =>
          PreWorkout(gymBagPrepped: false, energyLevel: 1, waterIntake: 500));

      // Mock getWorkoutHistory (for consistency)
      when(mockLocalStorageService.getWorkoutHistory()).thenAnswer((_) async => []);
    });

    testWidgets('SettingsScreen displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        Provider<LocalStorageService>(
          create: (_) => mockLocalStorageService,
          child: const MaterialApp(home: SettingsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('General'), findsOneWidget);
    });

    testWidgets('Updating name saves preferences', (WidgetTester tester) async {
      await tester.pumpWidget(
        Provider<LocalStorageService>(
          create: (_) => mockLocalStorageService,
          child: const MaterialApp(home: SettingsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'New User');
      await tester.pump();

      verify(mockLocalStorageService.saveUserPreferences(any)).called(1);
    });

    testWidgets('Toggling useKg saves preferences', (WidgetTester tester) async {
      await tester.pumpWidget(
        Provider<LocalStorageService>(
          create: (_) => mockLocalStorageService,
          child: const MaterialApp(home: SettingsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      verify(mockLocalStorageService.saveUserPreferences(any)).called(1);
    });

    testWidgets('Changing workout type saves preferences', (WidgetTester tester) async {
      await tester.pumpWidget(
        Provider<LocalStorageService>(
          create: (_) => mockLocalStorageService,
          child: const MaterialApp(home: SettingsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cardio').last);
      await tester.pumpAndSettle();

      verify(mockLocalStorageService.saveUserPreferences(any)).called(1);
    });
  });
}