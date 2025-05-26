import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:gym_tracker/models/workout.dart';
import 'package:gym_tracker/screens/water_tracker.dart';
import 'package:gym_tracker/services/local_storage_service.dart';
import '../mocks.mocks.dart';

void main() {
  group('WaterTracker Widget Tests', () {
    late MockLocalStorageService mockLocalStorageService;
    late Workout workout;

    setUp(() {
      mockLocalStorageService = MockLocalStorageService();
      workout = Workout(
        name: 'Leg Day',
        dayOfWeek: 'Tuesday',
        time: '17:00',
        type: 'Legs',
        waterIntake: 500.0,
      );

      when(mockLocalStorageService.saveWorkout(any)).thenAnswer((_) async => {});
    });

    testWidgets('Displays water intake correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        Provider<LocalStorageService>(
          create: (_) => mockLocalStorageService,
          child: MaterialApp(
            home: WaterTracker(workout: workout),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Water Intake (ml)'), findsOneWidget);
      expect(find.text('Current: 500 ml'), findsOneWidget);
    });

    testWidgets('Updates water intake', (WidgetTester tester) async {
      await tester.pumpWidget(
        Provider<LocalStorageService>(
          create: (_) => mockLocalStorageService,
          child: MaterialApp(
            home: WaterTracker(workout: workout),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final sliderCenter = tester.getCenter(find.byType(Slider));
      await tester.dragFrom(sliderCenter, const Offset(50.0, 0.0));
      await tester.pumpAndSettle();

      verify(mockLocalStorageService.saveWorkout(any)).called(1);
    });
  });
}