import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:city_weather/viewmodels/search_viewmodel.dart';
import 'package:city_weather/viewmodels/weather_viewmodel.dart';
import 'weather_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchViewModel = Provider.of<SearchViewModel>(context);
    final weatherViewModel = Provider.of<WeatherViewModel>(
      context,
      listen: false,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('City Weather'), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search City',
                hintText: 'Enter city name (e.g. Paris)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    searchViewModel.searchCities(_controller.text);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              onSubmitted: (value) {
                searchViewModel.searchCities(value);
              },
            ),
          ),
          // Favorites Section
          if (searchViewModel.favorites.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Favorites (${searchViewModel.favorites.length}/10)',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
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
                    itemCount: searchViewModel.favorites.length,
                    itemBuilder: (context, index) {
                      final city = searchViewModel.favorites[index];
                      return Card(
                        margin: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () {
                            weatherViewModel.fetchWeather(city);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WeatherScreen(),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 120,
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(Icons.location_city, size: 14),
                                    InkWell(
                                      onTap: () async {
                                        final success = await searchViewModel
                                            .removeFavorite(city);
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                success
                                                    ? 'Removed from favorites'
                                                    : 'Failed to remove favorite',
                                              ),
                                              duration: const Duration(
                                                seconds: 1,
                                              ),
                                            ),
                                          );
                                        }
                                      },
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
                                        color:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodySmall?.color,
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
                    },
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(),
              ],
            ),
          if (searchViewModel.isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (searchViewModel.errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                searchViewModel.errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: searchViewModel.cities.length,
                itemBuilder: (context, index) {
                  final city = searchViewModel.cities[index];
                  final isFav = searchViewModel.isFavorite(city);
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.location_city),
                      title: Text(
                        city.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('${city.country ?? ''}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              isFav ? Icons.star : Icons.star_border,
                              color: isFav ? Colors.amber : null,
                            ),
                            onPressed: () async {
                              if (isFav) {
                                final success = await searchViewModel
                                    .removeFavorite(city);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        success
                                            ? 'Removed from favorites'
                                            : 'Failed to remove favorite',
                                      ),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                }
                              } else {
                                final success = await searchViewModel
                                    .addFavorite(city);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        success
                                            ? 'Added to favorites'
                                            : 'Maximum 10 favorites reached',
                                      ),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                      onTap: () {
                        weatherViewModel.fetchWeather(city);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WeatherScreen(),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: Consumer<WeatherViewModel>(
        builder: (context, weatherViewModel, child) {
          return FloatingActionButton.extended(
            onPressed:
                weatherViewModel.isLoading
                    ? null
                    : () async {
                      await weatherViewModel.fetchWeatherByLocation();
                      if (context.mounted) {
                        if (weatherViewModel.errorMessage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(weatherViewModel.errorMessage!),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WeatherScreen(),
                            ),
                          );
                        }
                      }
                    },
            icon:
                weatherViewModel.isLoading
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
      ),
    );
  }
}
