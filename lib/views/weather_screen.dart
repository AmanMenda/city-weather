import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:city_weather/viewmodels/weather_viewmodel.dart';
import 'package:city_weather/viewmodels/search_viewmodel.dart';
import 'package:city_weather/widgets/weather/weather_icon_header.dart';
import 'package:city_weather/widgets/weather/temperature_display.dart';
import 'package:city_weather/widgets/weather/wind_speed_card.dart';
import 'package:city_weather/widgets/weather/open_map_button.dart';
import 'package:city_weather/widgets/common/error_message.dart';

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
        actions: city != null
            ? [
                Consumer<SearchViewModel>(
                  builder: (context, searchViewModel, child) {
                    final isFavorite = searchViewModel.isFavorite(city);
                    return IconButton(
                      icon: Icon(
                        isFavorite ? Icons.star : Icons.star_border,
                        color: isFavorite ? Colors.amber : Colors.white,
                      ),
                      onPressed: () async {
                        if (isFavorite) {
                          final success =
                              await searchViewModel.removeFavorite(city);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  success
                                      ? 'Removed from favorites'
                                      : 'Failed to remove favorite',
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        } else {
                          final success =
                              await searchViewModel.addFavorite(city);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  success
                                      ? 'Added to favorites'
                                      : 'Maximum 10 favorites reached',
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        }
                      },
                    );
                  },
                ),
              ]
            : null,
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
          child: weatherViewModel.isLoading
              ? const CircularProgressIndicator()
              : weatherViewModel.errorMessage != null
                  ? ErrorMessage(message: weatherViewModel.errorMessage!)
                  : weather == null
                      ? const Text('No weather data available')
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            WeatherIconHeader(
                              city: city,
                              weather: weather,
                            ),
                            const SizedBox(height: 32),
                            TemperatureDisplay(weather: weather),
                            const SizedBox(height: 16),
                            WindSpeedCard(weather: weather),
                            const SizedBox(height: 48),
                            OpenMapButton(
                              onPressed: () => weatherViewModel.openMap(),
                            ),
                          ],
                        ),
        ),
      ),
    );
  }
}
