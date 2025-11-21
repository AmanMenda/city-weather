import 'package:flutter/material.dart';
import 'package:city_weather/models/city.dart';

class FavoriteCard extends StatelessWidget {
  final City city;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const FavoriteCard({
    super.key,
    required this.city,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 120,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.location_city, size: 14),
                  InkWell(
                    onTap: onRemove,
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Text(
                  city.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              if (city.country != null)
                Flexible(
                  child: Text(
                    city.country!,
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

