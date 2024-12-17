import 'package:dtt_real_estate/Items/House.dart';
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

  Position createPosition(double latitude, double longitude) {
    return Position(
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
  }

  List<House> findHomes(List<House> houses, String searchText) {
    List<House> matchingHomes = [];

    // Normalize the search text by removing spaces and converting to lowercase
    String normalizedSearchText = searchText.replaceAll(' ', '').toLowerCase();

    for (var house in houses) {
      // Normalize the city and zip fields by removing spaces and converting to lowercase
      String normalizedCity = house.city.replaceAll(' ', '').toLowerCase();
      String normalizedZip = house.zip.replaceAll(' ', '').toLowerCase();

      if (house.id.toString().contains(searchText) ||
          normalizedCity.contains(normalizedSearchText) ||
          normalizedZip.contains(normalizedSearchText)) {
        matchingHomes.add(house);
      }
    }

    return matchingHomes;
  }
}
