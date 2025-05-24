import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker/screens/settings_screen.dart';
import 'package:gym_tracker/services/local_storage_service.dart';
import 'package:gym_tracker/models/user_preferences.dart';
import 'package:mockito/mockito.dart';

// Mock class for LocalStorageService
class MockLocalStorageService extends Mock implements LocalStorageService {
  UserPreferences _userPreferences = UserPreferences(name: 'Test User', useKg: true, preferredWorkoutType: 'General');

  @override
  Future<UserPreferences> getUserPreferences() async {
    return _userPreferences;
  }

  @override
  Future<void> saveUserPreferences(UserPreferences prefs) async {
    _userPreferences = prefs; // Store the passed UserPreferences
  }
}

void main() {
  group('SettingsScreen Widget Tests', () {
    late MockLocalStorageService mockLocalStorageService;

    setUp(() {
      mockLocalStorageService = MockLocalStorageService();
    });

    testWidgets('Renders correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<LocalStorageService>(
            create: (_) => mockLocalStorageService,
            child: const SettingsScreen(),
          ),
        ),
      );

      // Act
      await tester.pumpAndSettle(); // Wait for async operations to complete

      // Assert
      expect(find.text('Settings'), findsOneWidget); // AppBar title
      expect(find.text('Name'), findsOneWidget); // TextField label
      expect(find.text('Test User'), findsOneWidget); // Initial name from mock
      expect(find.text('Use Kilograms'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsOneWidget);
    });

    testWidgets('Saves preferences on input', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<LocalStorageService>(
            create: (_) => mockLocalStorageService,
            child: const SettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle(); // Wait for async operations

      // Act
      await tester.enterText(find.byType(TextField), 'New User');
      await tester.pump();

      // Simulate checkbox tap
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Simulate dropdown selection
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cardio').last);
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('New User'), findsOneWidget);
      verify(mockLocalStorageService.saveUserPreferences(argThat(isA<UserPreferences>()))).called(2); // Name and checkbox
    });
  });
}