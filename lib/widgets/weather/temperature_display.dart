import 'package:flutter/material.dart';
import 'package:city_weather/models/weather.dart';

class TemperatureDisplay extends StatelessWidget {
  final Weather weather;

  const TemperatureDisplay({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${weather.temperature}°C',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          weather.condition,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white70,
              ),
        ),
      ],
    );
  }
}

