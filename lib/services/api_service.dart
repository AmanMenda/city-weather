import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/city.dart';
import '../utils/constants.dart';

class ApiService {
  Future<List<City>> searchCities(String query) async {
    if (query.isEmpty) return [];
    final url = Uri.parse('${AppConstants.geocodingBaseUrl}?name=$query&count=5&language=fr');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null) {
        return (data['results'] as List).map((json) => City.fromJson(json)).toList();
      }
    }
    return [];
  }
}