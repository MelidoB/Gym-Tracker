import 'package:flutter/material.dart';
import 'package:gym_tracker/models/warm_up.dart';

class WarmupScreen extends StatelessWidget {
  final WarmUp warmUp;

  const WarmupScreen({super.key, required this.warmUp});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Warmup Routine'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              warmUp.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
            ),
            const SizedBox(height: 8),
            _buildDetailRow('Duration:', warmUp.duration),
            _buildDetailRow('Muscle Group:', warmUp.workoutType),
            const Divider(height: 40),
            Text(
              'Step-by-Step Instructions:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: _getInstructions().map((step) => _buildInstructionItem(step)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  List<String> _getInstructions() {
    switch (warmUp.workoutType.toLowerCase()) {
      case 'legs':
        return [
          '1. 5-minute dynamic stretching',
          '2. Bodyweight squats: 2×15',
          '3. Lunges with torso twist: 2×10/side',
          '4. Leg swings: 1×20/side',
          '5. Light resistance band work'
        ];
      case 'upper':
        return [
          '1. Arm circles: 1min forward/backward',
          '2. Band pull-aparts: 2×15',
          '3. Push-up to downward dog: 2×10',
          '4. Light dumbbell rows: 2×12',
          '5. Wrist mobility exercises'
        ];
      default:
        return [
          '1. Neck rotations: 1min clockwise/counter',
          '2. Arm swings: 2×20',
          '3. Torso twists: 2×20/side',
          '4. Bodyweight squats: 2×15',
          '5. Light cardio: 5min'
        ];
    }
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.arrow_right, size: 24),
          ),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}