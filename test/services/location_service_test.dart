import 'dart:async';

import 'package:city_weather/helpers/exceptions/location_exceptions.dart'
    as custom_exceptions;
import 'package:city_weather/services/location_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';

// Mock class for GeolocatorInterface
class MockGeolocatorInterface extends Mock implements GeolocatorInterface {}

void main() {
  late LocationService locationService;
  late MockGeolocatorInterface mockGeolocator;

  setUp(() {
    mockGeolocator = MockGeolocatorInterface();
    locationService = LocationService(geolocator: mockGeolocator);
  });

  group('LocationService', () {
    group('isLocationServiceEnabled', () {
      test('should return true when location service is enabled', () async {
        when(() => mockGeolocator.isLocationServiceEnabled())
            .thenAnswer((_) async => true);

        final result = await locationService.isLocationServiceEnabled();
        expect(result, isTrue);
        verify(() => mockGeolocator.isLocationServiceEnabled()).called(1);
      });

      test('should return false when location service is disabled', () async {
        when(() => mockGeolocator.isLocationServiceEnabled())
            .thenAnswer((_) async => false);
        final result = await locationService.isLocationServiceEnabled();
        expect(result, isFalse);
        verify(() => mockGeolocator.isLocationServiceEnabled()).called(1);
      });
    });

    group('checkPermission', () {
      test('should return LocationPermission.denied', () async {
        when(() => mockGeolocator.checkPermission())
            .thenAnswer((_) async => LocationPermission.denied);

        final result = await locationService.checkPermission();

        expect(result, equals(LocationPermission.denied));
        verify(() => mockGeolocator.checkPermission()).called(1);
      });

      test('should return LocationPermission.whileInUse', () async {
        when(() => mockGeolocator.checkPermission())
            .thenAnswer((_) async => LocationPermission.whileInUse);

        final result = await locationService.checkPermission();

        expect(result, equals(LocationPermission.whileInUse));
        verify(() => mockGeolocator.checkPermission()).called(1);
      });

      test('should return LocationPermission.always', () async {
        when(() => mockGeolocator.checkPermission())
            .thenAnswer((_) async => LocationPermission.always);

        final result = await locationService.checkPermission();

        expect(result, equals(LocationPermission.always));
        verify(() => mockGeolocator.checkPermission()).called(1);
      });

      test('should return LocationPermission.deniedForever', () async {
        when(() => mockGeolocator.checkPermission())
            .thenAnswer((_) async => LocationPermission.deniedForever);

        final result = await locationService.checkPermission();

        expect(result, equals(LocationPermission.deniedForever));
        verify(() => mockGeolocator.checkPermission()).called(1);
      });
    });

    group('requestPermission', () {
      test(
          'should throw LocationServiceDisabledException when GPS is disabled',
          () async {
        when(() => mockGeolocator.isLocationServiceEnabled())
            .thenAnswer((_) async => false);

        await expectLater(
          locationService.requestPermission(),
          throwsA(isA<custom_exceptions.LocationServiceDisabledException>()),
        );
        verify(() => mockGeolocator.isLocationServiceEnabled()).called(1);
        verifyNever(() => mockGeolocator.checkPermission());
      });

      test('should return true when permission is already granted (always)',
          () async {
        when(() => mockGeolocator.isLocationServiceEnabled())
            .thenAnswer((_) async => true);
        when(() => mockGeolocator.checkPermission())
            .thenAnswer((_) async => LocationPermission.always);

        final result = await locationService.requestPermission();

        expect(result, isTrue);
        verify(() => mockGeolocator.isLocationServiceEnabled()).called(1);
        verify(() => mockGeolocator.checkPermission()).called(1);
        verifyNever(() => mockGeolocator.requestPermission());
      });

      test(
          'should return true when permission is already granted (whileInUse)',
          () async {
        when(() => mockGeolocator.isLocationServiceEnabled())
            .thenAnswer((_) async => true);
        when(() => mockGeolocator.checkPermission())
            .thenAnswer((_) async => LocationPermission.whileInUse);

        final result = await locationService.requestPermission();

        expect(result, isTrue);
        verify(() => mockGeolocator.isLocationServiceEnabled()).called(1);
        verify(() => mockGeolocator.checkPermission()).called(1);
        verifyNever(() => mockGeolocator.requestPermission());
      });

      test(
          'should throw LocationPermissionDeniedException when permission is denied forever',
          () async {
        when(() => mockGeolocator.isLocationServiceEnabled())
            .thenAnswer((_) async => true);
        when(() => mockGeolocator.checkPermission())
            .thenAnswer((_) async => LocationPermission.deniedForever);

        await expectLater(
          locationService.requestPermission(),
          throwsA(isA<custom_exceptions.LocationPermissionDeniedException>()),
        );
        verify(() => mockGeolocator.isLocationServiceEnabled()).called(1);
        verify(() => mockGeolocator.checkPermission()).called(1);
        verifyNever(() => mockGeolocator.requestPermission());
      });

      test(
          'should throw LocationPermissionDeniedException when permission is denied after request',
          () async {
        when(() => mockGeolocator.isLocationServiceEnabled())
            .thenAnswer((_) async => true);
        when(() => mockGeolocator.checkPermission())
            .thenAnswer((_) async => LocationPermission.denied);
        when(() => mockGeolocator.requestPermission())
            .thenAnswer((_) async => LocationPermission.denied);

        await expectLater(
          locationService.requestPermission(),
          throwsA(isA<custom_exceptions.LocationPermissionDeniedException>()),
        );
        verify(() => mockGeolocator.isLocationServiceEnabled()).called(1);
        verify(() => mockGeolocator.checkPermission()).called(1);
        verify(() => mockGeolocator.requestPermission()).called(1);
      });

      test(
          'should throw LocationPermissionDeniedException when permission becomes deniedForever after request',
          () async {
        when(() => mockGeolocator.isLocationServiceEnabled())
            .thenAnswer((_) async => true);
        when(() => mockGeolocator.checkPermission())
            .thenAnswer((_) async => LocationPermission.denied);
        when(() => mockGeolocator.requestPermission())
            .thenAnswer((_) async => LocationPermission.deniedForever);

        await expectLater(
          locationService.requestPermission(),
          throwsA(isA<custom_exceptions.LocationPermissionDeniedException>()),
        );
        verify(() => mockGeolocator.isLocationServiceEnabled()).called(1);
        verify(() => mockGeolocator.checkPermission()).called(1);
        verify(() => mockGeolocator.requestPermission()).called(1);
      });

      test('should return true when permission is granted after request',
          () async {
        when(() => mockGeolocator.isLocationServiceEnabled())
            .thenAnswer((_) async => true);
        when(() => mockGeolocator.checkPermission())
            .thenAnswer((_) async => LocationPermission.denied);
        when(() => mockGeolocator.requestPermission())
            .thenAnswer((_) async => LocationPermission.whileInUse);

        final result = await locationService.requestPermission();

        expect(result, isTrue);
        verify(() => mockGeolocator.isLocationServiceEnabled()).called(1);
        verify(() => mockGeolocator.checkPermission()).called(1);
        verify(() => mockGeolocator.requestPermission()).called(1);
      });
    });

    group('getCurrentPosition', () {
      test(
          'should throw LocationServiceDisabledException when GPS is disabled',
          () async {
        when(() => mockGeolocator.isLocationServiceEnabled())
            .thenAnswer((_) async => false);

        await expectLater(
          locationService.getCurrentPosition(),
          throwsA(isA<custom_exceptions.LocationServiceDisabledException>()),
        );
        verify(() => mockGeolocator.isLocationServiceEnabled()).called(1);
        verifyNever(() => mockGeolocator.checkPermission());
      });

      test(
          'should throw LocationPermissionDeniedException when permission is denied forever',
          () async {
        when(() => mockGeolocator.isLocationServiceEnabled())
            .thenAnswer((_) async => true);
        when(() => mockGeolocator.checkPermission())
            .thenAnswer((_) async => LocationPermission.deniedForever);

        await expectLater(
          locationService.getCurrentPosition(),
          throwsA(isA<custom_exceptions.LocationPermissionDeniedException>()),
        );
        verify(() => mockGeolocator.isLocationServiceEnabled()).called(2);
        verify(() => mockGeolocator.checkPermission()).called(2);
        verifyNever(() => mockGeolocator.requestPermission());
      });

      test(
          'should throw LocationPermissionDeniedException when permission is denied and request fails',
          () async {
        when(() => mockGeolocator.isLocationServiceEnabled())
            .thenAnswer((_) async => true);
        when(() => mockGeolocator.checkPermission())
            .thenAnswer((_) async => LocationPermission.denied);
        when(() => mockGeolocator.requestPermission())
            .thenAnswer((_) async => LocationPermission.denied);

        await expectLater(
          locationService.getCurrentPosition(),
          throwsA(isA<custom_exceptions.LocationPermissionDeniedException>()),
        );
        verify(() => mockGeolocator.isLocationServiceEnabled()).called(2);
        verify(() => mockGeolocator.checkPermission()).called(2);
        verify(() => mockGeolocator.requestPermission()).called(1);
      });

      test('should return Position when successful', () async {
        final mockPosition = Position(
          latitude: 48.8566,
          longitude: 2.3522,
          timestamp: DateTime.now(),
          accuracy: 10.0,
          altitude: 0.0,
          altitudeAccuracy: 0.0,
          heading: 0.0,
          headingAccuracy: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        );

        when(() => mockGeolocator.isLocationServiceEnabled())
            .thenAnswer((_) async => true);
        when(() => mockGeolocator.checkPermission())
            .thenAnswer((_) async => LocationPermission.whileInUse);
        when(() => mockGeolocator.getCurrentPosition())
            .thenAnswer((_) async => mockPosition);
        final result = await locationService.getCurrentPosition();
        expect(result, equals(mockPosition));
        expect(result.latitude, equals(48.8566));
        expect(result.longitude, equals(2.3522));
        verify(() => mockGeolocator.isLocationServiceEnabled()).called(1);
        verify(() => mockGeolocator.checkPermission()).called(1);
        verify(() => mockGeolocator.getCurrentPosition()).called(1);
      });

      test('should throw LocationTimeoutException on timeout', () async {
        when(() => mockGeolocator.isLocationServiceEnabled())
            .thenAnswer((_) async => true);
        when(() => mockGeolocator.checkPermission())
            .thenAnswer((_) async => LocationPermission.whileInUse);
        when(() => mockGeolocator.getCurrentPosition())
            .thenThrow(TimeoutException('Timeout'));
        await expectLater(
          locationService.getCurrentPosition(),
          throwsA(isA<custom_exceptions.LocationTimeoutException>()),
        );
        verify(() => mockGeolocator.isLocationServiceEnabled()).called(1);
        verify(() => mockGeolocator.checkPermission()).called(1);
        verify(() => mockGeolocator.getCurrentPosition()).called(1);
      });

      test('should throw LocationException on generic error', () async {
        when(() => mockGeolocator.isLocationServiceEnabled())
            .thenAnswer((_) async => true);
        when(() => mockGeolocator.checkPermission())
            .thenAnswer((_) async => LocationPermission.whileInUse);
        when(() => mockGeolocator.getCurrentPosition())
            .thenThrow(Exception('Generic error'));
        await expectLater(
          locationService.getCurrentPosition(),
          throwsA(isA<custom_exceptions.LocationException>()),
        );
        verify(() => mockGeolocator.isLocationServiceEnabled()).called(1);
        verify(() => mockGeolocator.checkPermission()).called(1);
        verify(() => mockGeolocator.getCurrentPosition()).called(1);
      });

      test('should request permission when denied and then succeed', () async {
        final mockPosition = Position(
          latitude: 48.8566,
          longitude: 2.3522,
          timestamp: DateTime.now(),
          accuracy: 10.0,
          altitude: 0.0,
          altitudeAccuracy: 0.0,
          heading: 0.0,
          headingAccuracy: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        );

        when(() => mockGeolocator.isLocationServiceEnabled())
            .thenAnswer((_) async => true);
        when(() => mockGeolocator.checkPermission())
            .thenAnswer((_) async => LocationPermission.denied);
        when(() => mockGeolocator.requestPermission())
            .thenAnswer((_) async => LocationPermission.whileInUse);
        when(() => mockGeolocator.getCurrentPosition())
            .thenAnswer((_) async => mockPosition);

        final result = await locationService.getCurrentPosition();

        expect(result, equals(mockPosition));
        verify(() => mockGeolocator.isLocationServiceEnabled()).called(2);
        verify(() => mockGeolocator.checkPermission()).called(2);
        verify(() => mockGeolocator.requestPermission()).called(1);
        verify(() => mockGeolocator.getCurrentPosition()).called(1);
      });
    });

    group('getLastKnownPosition', () {
      test('should return null when GPS is disabled', () async {
        when(() => mockGeolocator.isLocationServiceEnabled())
            .thenAnswer((_) async => false);

        final result = await locationService.getLastKnownPosition();

        expect(result, isNull);
        verify(() => mockGeolocator.isLocationServiceEnabled()).called(1);
        verifyNever(() => mockGeolocator.checkPermission());
      });

      test('should return null when permission is denied', () async {
        when(() => mockGeolocator.isLocationServiceEnabled())
            .thenAnswer((_) async => true);
        when(() => mockGeolocator.checkPermission())
            .thenAnswer((_) async => LocationPermission.denied);

        final result = await locationService.getLastKnownPosition();

        expect(result, isNull);
        verify(() => mockGeolocator.isLocationServiceEnabled()).called(1);
        verify(() => mockGeolocator.checkPermission()).called(1);
        verifyNever(() => mockGeolocator.getLastKnownPosition());
      });

      test('should return null when permission is denied forever', () async {
        when(() => mockGeolocator.isLocationServiceEnabled())
            .thenAnswer((_) async => true);
        when(() => mockGeolocator.checkPermission())
            .thenAnswer((_) async => LocationPermission.deniedForever);

        final result = await locationService.getLastKnownPosition();

        expect(result, isNull);
        verify(() => mockGeolocator.isLocationServiceEnabled()).called(1);
        verify(() => mockGeolocator.checkPermission()).called(1);
        verifyNever(() => mockGeolocator.getLastKnownPosition());
      });

      test('should return Position when available', () async {
        final mockPosition = Position(
          latitude: 48.8566,
          longitude: 2.3522,
          timestamp: DateTime.now(),
          accuracy: 10.0,
          altitude: 0.0,
          altitudeAccuracy: 0.0,
          heading: 0.0,
          headingAccuracy: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        );

        when(() => mockGeolocator.isLocationServiceEnabled())
            .thenAnswer((_) async => true);
        when(() => mockGeolocator.checkPermission())
            .thenAnswer((_) async => LocationPermission.whileInUse);
        when(() => mockGeolocator.getLastKnownPosition())
            .thenAnswer((_) async => mockPosition);

        final result = await locationService.getLastKnownPosition();
        expect(result, equals(mockPosition));
        expect(result?.latitude, equals(48.8566));
        expect(result?.longitude, equals(2.3522));
        verify(() => mockGeolocator.isLocationServiceEnabled()).called(1);
        verify(() => mockGeolocator.checkPermission()).called(1);
        verify(() => mockGeolocator.getLastKnownPosition()).called(1);
      });

      test('should return null when no position is known', () async {
        when(() => mockGeolocator.isLocationServiceEnabled())
            .thenAnswer((_) async => true);
        when(() => mockGeolocator.checkPermission())
            .thenAnswer((_) async => LocationPermission.whileInUse);
        when(() => mockGeolocator.getLastKnownPosition())
            .thenAnswer((_) async => null);

  final result = await locationService.getLastKnownPosition();

        expect(result, isNull);
        verify(() => mockGeolocator.isLocationServiceEnabled()).called(1);
        verify(() => mockGeolocator.checkPermission()).called(1);
        verify(() => mockGeolocator.getLastKnownPosition()).called(1);
      });

      test('should return null on error', () async {
        when(() => mockGeolocator.isLocationServiceEnabled())
            .thenAnswer((_) async => true);
        when(() => mockGeolocator.checkPermission())
            .thenAnswer((_) async => LocationPermission.whileInUse);
        when(() => mockGeolocator.getLastKnownPosition())
            .thenThrow(Exception('Error'));

        final result = await locationService.getLastKnownPosition();

        expect(result, isNull);
        verify(() => mockGeolocator.isLocationServiceEnabled()).called(1);
        verify(() => mockGeolocator.checkPermission()).called(1);
        verify(() => mockGeolocator.getLastKnownPosition()).called(1);
      });
    });

    group('openLocationSettings', () {
      test('should call openLocationSettings and return true', () async {
        when(() => mockGeolocator.openLocationSettings())
            .thenAnswer((_) async => true);

        final result = await locationService.openLocationSettings();

        expect(result, isTrue);
        verify(() => mockGeolocator.openLocationSettings()).called(1);
      });

      test('should call openLocationSettings and return false', () async {
        when(() => mockGeolocator.openLocationSettings())
            .thenAnswer((_) async => false);


        final result = await locationService.openLocationSettings();

        expect(result, isFalse);
        verify(() => mockGeolocator.openLocationSettings()).called(1);
      });
    });
  });

  // Tests for exception types
  group('LocationService Exception Types', () {
    test('LocationServiceDisabledException should have correct message', () {
      const message = 'Test message';
      final exception = custom_exceptions.LocationServiceDisabledException(message);
      expect(exception.message, equals(message));
      expect(exception.toString(), contains('LocationServiceDisabledException'));
      expect(exception.toString(), contains(message));
    });

    test('LocationPermissionDeniedException should have correct message', () {
      const message = 'Test message';
      final exception = custom_exceptions.LocationPermissionDeniedException(message);
      expect(exception.message, equals(message));
      expect(exception.toString(), contains('LocationPermissionDeniedException'));
      expect(exception.toString(), contains(message));
    });

    test('LocationTimeoutException should have correct message', () {
      const message = 'Test message';
      final exception = custom_exceptions.LocationTimeoutException(message);
      expect(exception.message, equals(message));
      expect(exception.toString(), contains('LocationTimeoutException'));
      expect(exception.toString(), contains(message));
    });

    test('LocationException should have correct message', () {
      const message = 'Test message';
      final exception = custom_exceptions.LocationException(message);
      expect(exception.message, equals(message));
      expect(exception.toString(), contains('LocationException'));
      expect(exception.toString(), contains(message));
    });
  });
}
