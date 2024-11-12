import 'package:geolocator/geolocator.dart';

class Utils {
  double calculateDistance(Position userLocation, Position houseLocation) {
    print(userLocation.toJson());
    return Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      houseLocation.latitude,
      houseLocation.longitude,
    );
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
