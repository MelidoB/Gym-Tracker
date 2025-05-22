import 'package:flutter/material.dart';

class ReusableWidget extends StatelessWidget {
  final String label;

  const ReusableWidget({required this.label, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(label, style: TextStyle(fontSize: 18));
  }
}
