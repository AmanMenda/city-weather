# City Weather

Application météorologique développée en Flutter permettant de rechercher des villes, d'obtenir les prévisions météorologiques et d'utiliser la géolocalisation en temps réel.

## Fonctionnalités

- Recherche de ville avec autocomplétion via l'API Open-Meteo Geocoding
- Géolocalisation pour afficher la météo de la position actuelle
- Affichage des prévisions météorologiques (température, vitesse du vent) via Open-Meteo Forecast
- Navigation externe vers Google Maps / Plans pour visualiser la localisation
- Architecture MVVM avec gestion d'état via Provider

## Technologies

- **Langage :** Dart / Flutter SDK 3.38.2
- **Architecture :** MVVM (Model - View - ViewModel)
- **Gestion d'état :** Provider
- **Injection de dépendances :** GetIt

### Dépendances principales

| Package | Version | Usage |
| :--- | :--- | :--- |
| `provider` | `^6.1.5+1` | Gestion d'état |
| `geolocator` | `^14.0.2` | Accès au GPS |
| `permission_handler` | `^12.0.1` | Gestion des permissions |
| `http` | `^1.6.0` | Appels API REST |
| `url_launcher` | `^6.3.2` | Ouverture des liens externes |
| `get_it` | `^9.0.5` | Injection de dépendances |
| `logger` | `^2.6.2` | Logging |
| `mocktail` | `^1.0.0` | Mocking pour les tests |

## Architecture

Le projet suit le pattern MVVM pour séparer la logique métier de l'interface utilisateur :

- **Models :** Représentation des données (City, Weather)
- **Views :** Interface utilisateur (SearchScreen, WeatherScreen)
- **ViewModels :** Logique métier et gestion d'état (SearchViewModel, WeatherViewModel)
- **Services :** Accès aux APIs et fonctionnalités système (ApiService, LocationService, MapService)
- **Interfaces :** Abstraction pour faciliter les tests (GeolocatorInterface)
- **Implementations :** Implémentations concrètes (GeolocatorWrapper)

## Installation

1. Cloner le projet :

```bash
git clone <repository-url>
cd city-weather
```

2. Installer les dépendances :

```bash
flutter pub get
```

3. Configuration des permissions :

**Android :** Les permissions `ACCESS_FINE_LOCATION` et `ACCESS_COARSE_LOCATION` sont configurées dans `android/app/src/main/AndroidManifest.xml`.

**iOS :** Les clés `NSLocationWhenInUseUsageDescription` et `NSLocationAlwaysAndWhenInUseUsageDescription` sont configurées dans `ios/Runner/Info.plist`.

4. Lancer l'application :

```bash
flutter run
```

## Tests

Exécuter les tests unitaires :

```bash
flutter test
```

Les tests utilisent `mocktail` pour mocker les dépendances et tester l'isolation des services.

## APIs externes

Le projet utilise les APIs gratuites d'Open-Meteo (aucune clé API requise) :

- **Geocoding :** `https://geocoding-api.open-meteo.com/v1/search`
- **Forecast :** `https://api.open-meteo.com/v1/forecast`

## Auteurs

- Charmeel Vodouhe
- Aman Menda
