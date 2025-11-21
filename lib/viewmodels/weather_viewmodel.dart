import 'package:flutter/material.dart';
import 'package:city_weather/models/city.dart';
import 'package:city_weather/models/weather.dart';
import 'package:city_weather/services/api_service.dart';
import 'package:city_weather/services/location_service.dart';
import 'package:city_weather/services/google_map_service.dart';

class WeatherViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final LocationService _locationService = LocationService();
  final MapService _mapService = MapService();

  Weather? _weather;
  Weather? get weather => _weather;

  City? _currentCity;
  City? get currentCity => _currentCity;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchWeather(City city) async {
    _currentCity = city;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _weather = await _apiService.getWeather(city.latitude, city.longitude);
    } catch (e) {
      _errorMessage = 'Failed to load weather: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWeatherByLocation() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentPosition();
      // We don't have city name from GPS directly without reverse geocoding,
      // but the requirements just say "Display weather of the city via Open-Meteo Forecast".
      // We can create a temporary City object or just display coordinates if needed.
      // For better UX, let's assume we treat it as "Current Location".
      _currentCity = City(
        name: "Current Location",
        latitude: position.latitude,
        longitude: position.longitude,
      );

      _weather = await _apiService.getWeather(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      _errorMessage = 'Failed to get location or weather: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> openMap() async {
    if (_currentCity != null) {
      try {
        await _mapService.openMap(
          _currentCity!.latitude,
          _currentCity!.longitude,
        );
      } catch (e) {
        _errorMessage = 'Could not open map: $e';
        notifyListeners();
      }
    }
  }
}
