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
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.location_city),
                      title: Text(
                        city.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(city.country ?? ''),
                      trailing: const Icon(Icons.chevron_right),
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
