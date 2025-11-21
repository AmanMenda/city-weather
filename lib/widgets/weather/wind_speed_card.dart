import 'package:flutter/material.dart';
import 'package:city_weather/models/weather.dart';

class WindSpeedCard extends StatelessWidget {
  final Weather weather;

  const WindSpeedCard({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withValues(alpha: 0.2),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.air, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              'Wind Speed',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
            ),
            Text(
              '${weather.windSpeed} km/h',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

