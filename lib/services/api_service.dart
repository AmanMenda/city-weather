import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/city.dart';
import '../models/weather.dart';
import '../utils/constants.dart';

class ApiService {
  Future<List<City>> searchCities(String query) async {
    if (query.isEmpty) return [];
    final url = Uri.parse(
      '${AppConstants.geocodingBaseUrl}?name=$query&count=5&language=fr',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null) {
        return (data['results'] as List)
            .map((json) => City.fromJson(json))
            .toList();
      }
    }
    return [];
  }

  Future<Weather> getWeather(double lat, double lon) async {
    final url = Uri.parse(
      '${AppConstants.weatherBaseUrl}?latitude=$lat&longitude=$lon&current=temperature_2m,wind_speed_10m,weather_code',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }
}
