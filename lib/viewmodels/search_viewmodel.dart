import 'package:flutter/material.dart';
import 'package:city_weather/models/city.dart';
import 'package:city_weather/models/weather.dart';
import 'package:city_weather/services/api_service.dart';
import 'package:city_weather/services/favorite_service.dart';

class SearchViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final FavoriteService _favoriteService = FavoriteService();

  List<City> _cities = [];
  List<City> get cities => _cities;

  List<City> _favorites = [];
  List<City> get favorites => _favorites;

  Map<City, Weather?> _favoritesWeather = {};
  Map<City, Weather?> get favoritesWeather => _favoritesWeather;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingFavorites = false;
  bool get isLoadingFavorites => _isLoadingFavorites;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  SearchViewModel() {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    _isLoadingFavorites = true;
    notifyListeners();

    try {
      _favorites = await _favoriteService.getFavorites();
      await loadFavoritesWeather();
    } catch (e) {
      _errorMessage = 'Failed to load favorites: $e';
    } finally {
      _isLoadingFavorites = false;
      notifyListeners();
    }
  }

  Future<void> loadFavoritesWeather() async {
    _favoritesWeather.clear();
    for (final city in _favorites) {
      try {
        final weather = await _apiService.getWeather(
          city.latitude,
          city.longitude,
        );
        _favoritesWeather[city] = weather;
      } catch (e) {
        _favoritesWeather[city] = null;
      }
    }
    notifyListeners();
  }

  Weather? getFavoriteWeather(City city) {
    return _favoritesWeather[city];
  }

  Future<bool> addFavorite(City city) async {
    try {
      final success = await _favoriteService.addFavorite(city);
      if (success) {
        await loadFavorites();
        try {
          final weather = await _apiService.getWeather(
            city.latitude,
            city.longitude,
          );
          _favoritesWeather[city] = weather;
          notifyListeners();
        } catch (e) {
          _favoritesWeather[city] = null;
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      _errorMessage = 'Failed to add favorite: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> removeFavorite(City city) async {
    try {
      final success = await _favoriteService.removeFavorite(city);
      if (success) {
        await loadFavorites();
      }
      return success;
    } catch (e) {
      _errorMessage = 'Failed to remove favorite: $e';
      notifyListeners();
      return false;
    }
  }

  bool isFavorite(City city) {
    return _favorites.any((c) => c.isSameLocation(city));
  }

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
