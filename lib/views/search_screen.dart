import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:city_weather/models/city.dart';
import 'package:city_weather/viewmodels/search_viewmodel.dart';
import 'package:city_weather/viewmodels/weather_viewmodel.dart';
import 'package:city_weather/widgets/search/city_search_field.dart';
import 'package:city_weather/widgets/search/favorites_section.dart';
import 'package:city_weather/widgets/search/city_list_item.dart';
import 'package:city_weather/widgets/search/location_floating_button.dart';
import 'package:city_weather/widgets/common/loading_indicator.dart';
import 'package:city_weather/widgets/common/error_message.dart';
import 'package:city_weather/views/weather_screen.dart';

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

  void _handleFavoriteTap(City city) {
    final weatherViewModel = Provider.of<WeatherViewModel>(
      context,
      listen: false,
    );
    weatherViewModel.fetchWeather(city);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WeatherScreen(),
      ),
    );
  }

  void _handleFavoriteRemove(City city) async {
    final searchViewModel = Provider.of<SearchViewModel>(context);
    final success = await searchViewModel.removeFavorite(city);
    if (mounted) {
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
  }

  void _handleCityTap(City city) {
    final weatherViewModel = Provider.of<WeatherViewModel>(
      context,
      listen: false,
    );
    weatherViewModel.fetchWeather(city);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WeatherScreen(),
      ),
    );
  }

  void _handleFavoriteToggle(City city) async {
    final searchViewModel = Provider.of<SearchViewModel>(context);
    final isFavorite = searchViewModel.isFavorite(city);

    if (isFavorite) {
      final success = await searchViewModel.removeFavorite(city);
      if (mounted) {
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
      final success = await searchViewModel.addFavorite(city);
      if (mounted) {
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
  }

  void _handleLocationSuccess() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WeatherScreen(),
      ),
    );
  }

  void _handleLocationError() {
    final weatherViewModel = Provider.of<WeatherViewModel>(
      context,
      listen: false,
    );
    if (mounted && weatherViewModel.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(weatherViewModel.errorMessage!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchViewModel = Provider.of<SearchViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('City Weather'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          CitySearchField(
            controller: _controller,
            onSearch: () => searchViewModel.searchCities(_controller.text),
          ),
          FavoritesSection(
            favorites: searchViewModel.favorites,
            onFavoriteTap: _handleFavoriteTap,
            onFavoriteRemove: _handleFavoriteRemove,
          ),
          if (searchViewModel.isLoading)
            const LoadingIndicator()
          else if (searchViewModel.errorMessage != null)
            ErrorMessage(message: searchViewModel.errorMessage!)
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: searchViewModel.cities.length,
                itemBuilder: (context, index) {
                  final city = searchViewModel.cities[index];
                  return CityListItem(
                    city: city,
                    isFavorite: searchViewModel.isFavorite(city),
                    onTap: () => _handleCityTap(city),
                    onFavoriteToggle: () => _handleFavoriteToggle(city),
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: LocationFloatingButton(
        onSuccess: _handleLocationSuccess,
        onError: _handleLocationError,
      ),
    );
  }
}
