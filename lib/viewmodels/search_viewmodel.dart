import 'package:flutter/material.dart';
import 'package:city_weather/models/city.dart';
import 'package:city_weather/services/api_service.dart';

class SearchViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<City> _cities = [];
  List<City> get cities => _cities;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> searchCities(String query) async {
    if (query.isEmpty) {
      _cities = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cities = await _apiService.searchCities(query);
    } catch (e) {
      _errorMessage = 'Failed to search cities: $e';
      _cities = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
