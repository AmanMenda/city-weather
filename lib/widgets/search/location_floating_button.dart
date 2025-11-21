import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:city_weather/viewmodels/weather_viewmodel.dart';

class LocationFloatingButton extends StatelessWidget {
  final VoidCallback? onSuccess;
  final VoidCallback? onError;

  const LocationFloatingButton({
    super.key,
    this.onSuccess,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherViewModel>(
      builder: (context, weatherViewModel, child) {
        return FloatingActionButton.extended(
          onPressed: weatherViewModel.isLoading
              ? null
              : () async {
                  await weatherViewModel.fetchWeatherByLocation();
                  if (context.mounted) {
                    if (weatherViewModel.errorMessage != null) {
                      onError?.call();
                    } else {
                      onSuccess?.call();
                    }
                  }
                },
          icon: weatherViewModel.isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.my_location),
          label: Text(
            weatherViewModel.isLoading ? 'Locating...' : 'My Location',
          ),
        );
      },
    );
  }
}

