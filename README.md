# city-weather
Application météo développée en Flutter permettant de rechercher des villes, d'obtenir les prévisions météorologiques et d'utiliser la géolocalisation en temps réel.

## 📱 Fonctionnalités

  * **🔎 Recherche de ville :** Autocomplétion et recherche via l'API *Open-Meteo Geocoding*.
  * **📍 Géolocalisation :** Détection de la position actuelle (GPS) pour afficher la météo locale.
  * **🌡️ Météo détaillée :** Affichage de la température et de la vitesse du vent via *Open-Meteo Forecast*.
  * **🗺️ Navigation externe :** Redirection vers Google Maps / Plans pour visualiser la ville.
  * **⚡ Architecture MVVM :** Utilisation de `Provider` pour une gestion d'état propre.

## 🛠️ Stack Technique

  * **Langage :** Dart / Flutter SDK
  * **Architecture :** MVVM (Model - View - ViewModel)
  * **Gestion d'état :** `provider`

### Packages utilisés

| Package | Version | Usage |
| :--- | :--- | :--- |
| `http` | `^1.2.0` | Appels API REST |
| `geolocator` | `^12.0.0` | Accès au GPS du téléphone |
| `url_launcher`| `^6.3.0` | Ouverture des liens externes (Maps) |
| `provider` | `(latest)`| State Management |

## 🧱 Architecture du projet

Le projet respecte le pattern **MVVM** pour séparer la logique métier de l'interface utilisateur.


## 🚀 Installation et Lancement

1.  **Cloner le projet :**

    ```bash
    git clone https://github.com/votre-username/cityweather.git
    cd cityweather
    ```

2.  **Installer les dépendances :**

    ```bash
    flutter pub get
    ```

3.  **Configuration des permissions (Android/iOS) :**

      * *Android :* Vérifier les permissions `ACCESS_FINE_LOCATION` dans `AndroidManifest.xml`.
      * *iOS :* Vérifier les clés `NSLocationWhenInUseUsageDescription` dans `Info.plist`.

4.  **Lancer l'application :**

    ```bash
    flutter run
    ```

## 🌐 APIs Externes (Open Source)

Ce projet utilise les APIs gratuites d'Open-Meteo (aucune clé API requise) :

  * **Geocoding :** `https://geocoding-api.open-meteo.com/v1/search`
  * **Météo :** `https://api.open-meteo.com/v1/forecast`

## 👥 Auteurs

**Binôme :**

  * Charmeel Vodouhe
  * Aman Menda
