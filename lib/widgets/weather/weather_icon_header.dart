import 'package:flutter/material.dart';
import 'package:city_weather/models/city.dart';
import 'package:city_weather/models/weather.dart';

class WeatherIconHeader extends StatelessWidget {
  final City? city;
  final Weather weather;

  const WeatherIconHeader({
    super.key,
    required this.city,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(weather.icon, size: 100, color: Colors.white),
        const SizedBox(height: 16),
        Text(
          city?.name ?? 'Unknown Location',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
              ),
        ),
        if (city?.country != null)
          Text(
            city!.country!,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white70,
                ),
          ),
      ],
    );
  }
}

