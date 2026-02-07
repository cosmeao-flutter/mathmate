import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

/// Service class wrapping `geolocator` and `geocoding` plugins for
/// detecting the user's city and region (state).
///
/// Unlike repository classes (which wrap SharedPreferences), this service
/// wraps native plugins that interact with Core Location and CLGeocoder.
class LocationService {
  /// Creates a [LocationService] instance.
  ///
  /// No async initialization needed — plugins are ready immediately.
  LocationService();

  /// Requests location permission from the user.
  ///
  /// Returns `true` if permission was granted
  /// (either [LocationPermission.always] or
  /// [LocationPermission.whileInUse]), `false` otherwise.
  Future<bool> requestPermission() async {
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  /// Detects the user's city and region via GPS and reverse geocoding.
  ///
  /// Returns a record `(city:, region:)` on success, or `null` if:
  /// - Location services are disabled
  /// - No placemarks found
  /// - An error occurs during detection
  Future<({String city, String region})?> detectCityAndRegion() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      final position = await Geolocator.getCurrentPosition();

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) return null;

      final placemark = placemarks.first;
      return (
        city: placemark.locality ?? '',
        region: placemark.administrativeArea ?? '',
      );
    } on Exception {
      return null;
    }
  }
}
