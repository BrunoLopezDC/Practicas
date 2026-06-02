import 'package:flutter/material.dart';
import 'weather_icon.dart';

class TemperatureCard extends StatelessWidget {
  final String day;
  final String temperature;
  final String condition;

  const TemperatureCard({
    Key? key,
    required this.day,
    required this.temperature,
    required this.condition,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              day,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            WeatherIcon(condition: condition, size: 40),
            const SizedBox(height: 12),
            Text(
              temperature,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}