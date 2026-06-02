import 'package:flutter/material.dart';

class WeatherIcon extends StatelessWidget {
  final String condition;
  final double size;

  const WeatherIcon({
    Key? key, 
    required this.condition, 
    this.size = 80,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    
    switch (condition.toLowerCase()) {
      case 'sunny':
        iconData = Icons.wb_sunny;
        break;
      case 'rainy':
        iconData = Icons.water_drop;
        break;
      case 'cloudy':
      default:
        iconData = Icons.cloud;
    }

    return Icon(
      iconData,
      size: size,
      color: Colors.red,
    );
  }
}