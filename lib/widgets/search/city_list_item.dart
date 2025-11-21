import 'package:flutter/material.dart';
import 'package:city_weather/models/city.dart';

class CityListItem extends StatelessWidget {
  final City city;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const CityListItem({
    super.key,
    required this.city,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.location_city),
        title: Text(
          city.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(city.country ?? ''),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? Colors.amber : null,
              ),
              onPressed: onFavoriteToggle,
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

