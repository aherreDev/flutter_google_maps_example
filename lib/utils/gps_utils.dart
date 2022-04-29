import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlng/latlng.dart';
// import 'package:google_geocoding/google_geocoding.dart';

// ------------------------------------------------------------ //
//                       GPS native                             //
// ------------------------------------------------------------ //

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

double fetchLatitude(Position position) => position.latitude;

double fetchLongitude(Position position) => position.longitude;

// ------------------------------------------------------------ //
//                    Geocoding API                             //
// ------------------------------------------------------------ //

// Future<String> reverseGeocoding(
//     GoogleGeocoding googleGeocoding, double lat, double lng) async {
//   LatLon latLon = LatLon(19.2509429, -103.6941785);

//   GeocodingResponse? response =
//       await googleGeocoding.geocoding.getReverse(latLon);

//   return response?.results?.first?.formattedAddress ?? 'Unknown';
// }

String placemarkToString(Placemark? placemark) {
  if (placemark == null) {
    return 'Unknown';
  }

  return '${placemark.name}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.postalCode}, ${placemark.country}';
}

Future<String> reverseGeocoding(double lat, double lng) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

  return placemarkToString(placemarks.first);
}

Future<LatLng?> geocodingByAddress(String address) async {
  List<Location> locations = await locationFromAddress(address);
  if (locations.isEmpty) {
    return null;
  }

  return LatLng(locations.first.latitude, locations.first.longitude);
}
