import 'package:flutter/material.dart';

class Weather {
  final double temperature;
  final double windSpeed;
  final int weatherCode;

  Weather({
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    return Weather(
      temperature: (current['temperature_2m'] as num).toDouble(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
    );
  }

  String get condition {
    if (weatherCode == 0) return 'Clear Sky';
    if (weatherCode >= 1 && weatherCode <= 3) return 'Cloudy';
    if (weatherCode >= 45 && weatherCode <= 48) return 'Foggy';
    if (weatherCode >= 51 && weatherCode <= 67) return 'Rainy';
    if (weatherCode >= 71 && weatherCode <= 77) return 'Snowy';
    if (weatherCode >= 80 && weatherCode <= 82) return 'Rain Showers';
    if (weatherCode >= 95 && weatherCode <= 99) return 'Thunderstorm';
    return 'Unknown';
  }

  IconData get icon {
    if (weatherCode == 0) return Icons.wb_sunny;
    if (weatherCode >= 1 && weatherCode <= 3) return Icons.cloud;
    if (weatherCode >= 45 && weatherCode <= 48) return Icons.foggy;
    if (weatherCode >= 51 && weatherCode <= 67) return Icons.grain;
    if (weatherCode >= 71 && weatherCode <= 77) return Icons.ac_unit;
    if (weatherCode >= 80 && weatherCode <= 82) return Icons.umbrella;
    if (weatherCode >= 95 && weatherCode <= 99) return Icons.flash_on;
    return Icons.help_outline;
  }

  Color get color {
    if (weatherCode == 0) return Colors.orangeAccent;
    if (weatherCode >= 1 && weatherCode <= 3) return Colors.blueGrey;
    if (weatherCode >= 45 && weatherCode <= 48) return Colors.grey;
    if (weatherCode >= 51 && weatherCode <= 67) return Colors.blue;
    if (weatherCode >= 71 && weatherCode <= 77) return Colors.cyan;
    if (weatherCode >= 80 && weatherCode <= 82) return Colors.indigo;
    if (weatherCode >= 95 && weatherCode <= 99) return Colors.deepPurple;
    return Colors.teal;
  }
}
