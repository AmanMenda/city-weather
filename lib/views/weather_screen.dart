import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:city_weather/viewmodels/weather_viewmodel.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherViewModel = Provider.of<WeatherViewModel>(context);
    final city = weatherViewModel.currentCity;
    final weather = weatherViewModel.weather;

    return Scaffold(
      appBar: AppBar(
        title: Text(city?.name ?? 'Weather'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [weather?.color ?? Colors.blueGrey, Colors.black],
          ),
        ),
        child: Center(
          child:
              weatherViewModel.isLoading
                  ? const CircularProgressIndicator()
                  : weatherViewModel.errorMessage != null
                  ? Text(
                    weatherViewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  )
                  : weather == null
                  ? const Text('No weather data available')
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(weather.icon, size: 100, color: Colors.white),
                      const SizedBox(height: 16),
                      Text(
                        city?.name ?? 'Unknown Location',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(color: Colors.white),
                      ),
                      if (city?.country != null)
                        Text(
                          city!.country!,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.white70),
                        ),
                      const SizedBox(height: 32),
                      Text(
                        '${weather.temperature}°C',
                        style: Theme.of(
                          context,
                        ).textTheme.displayLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        weather.condition,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        color: Colors.white.withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Icon(Icons.air, color: Colors.white),
                              const SizedBox(height: 8),
                              Text(
                                'Wind Speed',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.white70),
                              ),
                              Text(
                                '${weather.windSpeed} km/h',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      ElevatedButton.icon(
                        onPressed: () {
                          weatherViewModel.openMap();
                        },
                        icon: const Icon(Icons.map),
                        label: const Text('Open in Maps'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
