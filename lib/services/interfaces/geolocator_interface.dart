import 'package:geolocator/geolocator.dart';

/// Interface for Geolocator operations to enable testing
abstract class GeolocatorInterface {
  Future<bool> isLocationServiceEnabled();
  Future<LocationPermission> checkPermission();
  Future<LocationPermission> requestPermission();
  Future<Position> getCurrentPosition();
  Future<Position?> getLastKnownPosition();
  Future<bool> openLocationSettings();
}
