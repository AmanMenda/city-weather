import 'package:city_weather/viewmodels/search_viewmodel.dart';
import 'package:city_weather/views/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:city_weather/viewmodels/weather_viewmodel.dart';

void main() {
  runApp(const CityWeatherApp());
}

class CityWeatherApp extends StatelessWidget {
  const CityWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SearchViewModel()),
        ChangeNotifierProvider(create: (_) => WeatherViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'City Weather',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const SearchScreen(),
      ),
    );
  }
}
