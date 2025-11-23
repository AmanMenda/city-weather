import 'package:city_weather/models/city.dart';
import 'package:city_weather/services/database_service.dart';

class FavoriteService {
  final DatabaseService _db = DatabaseService.instance;
  static const int maxFavorites = 10;

  Future<List<City>> getFavorites() async {
    try {
      final maps = await _db.query(
        DatabaseService.tableFavorites,
        orderBy: 'created_at DESC',
      );
      return maps.map((map) => City.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get favorites: $e');
    }
  }

  Future<bool> addFavorite(City city) async {
    try {
      // Check if limit reached
      final count = await _db.count(DatabaseService.tableFavorites);
      if (count >= maxFavorites) {
        return false;
      }

      // Check if already exists
      if (await isFavorite(city)) {
        return false;
      }

      final id = await _db.insert(DatabaseService.tableFavorites, city.toMap());

      return id > 0;
    } catch (e) {
      throw Exception('Failed to add favorite: $e');
    }
  }

  Future<bool> removeFavorite(City city) async {
    try {
      final count = await _db.delete(
        DatabaseService.tableFavorites,
        'name = ? AND latitude = ? AND longitude = ?',
        [city.name, city.latitude, city.longitude],
      );
      return count > 0;
    } catch (e) {
      throw Exception('Failed to remove favorite: $e');
    }
  }

  Future<bool> isFavorite(City city) async {
    try {
      final favorites = await getFavorites();
      return favorites.any((c) => c.isSameLocation(city));
    } catch (e) {
      return false;
    }
  }

  Future<int> getFavoritesCount() async {
    try {
      return await _db.count(DatabaseService.tableFavorites);
    } catch (e) {
      return 0;
    }
  }
}
