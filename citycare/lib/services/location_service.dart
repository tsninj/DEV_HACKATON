import 'package:geolocator/geolocator.dart';

// Ashiglah zaavar
// final service = LocationService();
// final position = await service.getCurrentLocation();
class LocationService {
  Future<Position> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied (user denied).');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied, cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}