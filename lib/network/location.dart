import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are not enabled');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      return Future.error("Location services are denied");
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location services are permanently denied');
    }
  }

  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best);
}

Future<String> getAddress(Position position) async {
  List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
  Placemark place = placemarks[0];
  print(place.locality);
  return '${place.locality}';
}
