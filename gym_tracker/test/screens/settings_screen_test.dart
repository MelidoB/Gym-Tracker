import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker/models/user_preferences.dart';
import 'package:gym_tracker/services/local_storage_service.dart';
import 'package:gym_tracker/screens/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SettingsScreen Widget Tests', () {
    late LocalStorageService localStorageService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      localStorageService = LocalStorageService();
    });

    testWidgets('Renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<LocalStorageService>.value(
            value: localStorageService,
            child: const SettingsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Name'), findsOneWidget);
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.byType(DropdownButton<String>), findsOneWidget);
    });

    testWidgets('Saves preferences on input', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<LocalStorageService>.value(
            value: localStorageService,
            child: const SettingsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Enter name
      await tester.enterText(find.byType(TextField), 'John');
      await tester.pump();

      // Toggle checkbox
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Select workout type
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cardio').last);
      await tester.pumpAndSettle();

      final prefs = await localStorageService.getUserPreferences();
      expect(prefs.name, 'John');
      expect(prefs.useKg, true);
      expect(prefs.preferredWorkoutType, 'Cardio');
    });
  });
}