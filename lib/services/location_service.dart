import 'dart:async';

import 'package:city_weather/helpers/exceptions/location_exceptions.dart' as custom_exceptions;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class LocationService {
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  Future<bool> requestPermission() async {
    if (!await isLocationServiceEnabled()) {
      throw custom_exceptions.LocationServiceDisabledException(
        "Location services are disabled. Please enable GPS in your device settings."
      );
    }

    LocationPermission permission = await checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return true;
    }
    if (permission == LocationPermission.deniedForever) {
      throw custom_exceptions.LocationPermissionDeniedException(
        'Location permission is permanently denied. Please enable it in app settings.',
      );
    }

    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw custom_exceptions.LocationPermissionDeniedException(
        'Location permission was denied. Please grant location access to use this feature.',
      );
    }
    if (permission == LocationPermission.deniedForever) {
      throw custom_exceptions.LocationPermissionDeniedException(
        'Location permission is permanently denied. Please enable it in app settings.',
      );
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<Position> getCurrentPosition() async {
    try {
      if (!await isLocationServiceEnabled()) {
        throw custom_exceptions.LocationServiceDisabledException(
          'Location services are disabled. Please enable GPS in your device settings.',
        );
      }

      LocationPermission permission = await checkPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!await requestPermission()) {
          throw custom_exceptions.LocationPermissionDeniedException(
            'Location permission is required to get your current position.',
          );
        }
      }

      try {
        return await Geolocator.getCurrentPosition();
      } on TimeoutException {
        throw custom_exceptions.LocationTimeoutException(
          'Location request timed out. Please check your GPS signal and try again.',
        );
      } catch (e) {
        if (e is custom_exceptions.LocationPermissionDeniedException ||
            e is custom_exceptions.LocationServiceDisabledException ||
            e is custom_exceptions.LocationTimeoutException) {
          rethrow;
        }
        throw custom_exceptions.LocationException(
          'Failed to get current position: ${e.toString()}',
        );
      }
    } catch (e) {
      if (e is custom_exceptions.LocationPermissionDeniedException ||
          e is LocationServiceDisabledException ||
          e is custom_exceptions.LocationTimeoutException ||
          e is custom_exceptions.LocationException) {
        rethrow;
      }
      throw custom_exceptions.LocationException(
        'An unexpected error occurred while getting location: ${e.toString()}',
      );
    }
  }

  Future<Position?> getLastKnownPosition() async {
    try {
      final isEnabled = await isLocationServiceEnabled();
      if (!isEnabled) {
        return null;
      }

      LocationPermission permission = await checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getLastKnownPosition();
    } catch (e) {
      return null;
    }
  }

  Future<bool> openAppSettings() async {
    return await ph.openAppSettings();
  }

  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }
}

