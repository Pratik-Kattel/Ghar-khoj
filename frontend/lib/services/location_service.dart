import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position> getUserLocation() async {
    LocationPermission permission;
    bool _isEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_isEnabled) {
      return Future.error(
        "Location service is disabled. Please enable GPS services to continue.",
      );
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      return Future.error("Location permission is denied");
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permission is denied permanently");
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
