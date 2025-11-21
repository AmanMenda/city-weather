import 'package:flutter/material.dart';
import 'package:city_weather/models/city.dart';
import 'package:city_weather/models/weather.dart';
import 'package:city_weather/widgets/search/favorite_card.dart';

class FavoritesSection extends StatelessWidget {
  final List<City> favorites;
  final Function(City) onFavoriteTap;
  final Function(City) onFavoriteRemove;
  final Map<City, Weather?> favoritesWeather;

  const FavoritesSection({
    super.key,
    required this.favorites,
    required this.onFavoriteTap,
    required this.onFavoriteRemove,
    required this.favoritesWeather,
  });

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Text(
                'Favorites (${favorites.length}/10)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final city = favorites[index];
              return FavoriteCard(
                city: city,
                weather: favoritesWeather[city],
                onTap: () => onFavoriteTap(city),
                onRemove: () => onFavoriteRemove(city),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        const Divider(),
      ],
    );
  }
}

