import 'package:flutter/material.dart';
import 'package:flutter_google_maps_example/widgets/location_form.dart';
import 'package:flutter_google_maps_example/widgets/map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';

import '../utils/gps_utils.dart';

class IndexView extends StatefulWidget {
  const IndexView({Key? key}) : super(key: key);

  @override
  State<IndexView> createState() => _IndexViewState();
}

class _IndexViewState extends State<IndexView> {
  LatLng? location;
  String address = '';
  List<LatLng> markers = [];

  MapController controller = MapController(
    location: LatLng(0, 0),
  );

  @override
  void initState() {
    _loadCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geo Hack'),
      ),
      body: indexBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _gotoDefault,
        tooltip: 'My Location',
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Column indexBody() {
    return Column(
      children: [
        LocationForm(
            handleNewMarker: _saveNewMarker,
            currentLocation: location,
            currentAddress: address),
        MapWidget(controller: controller, markers: markers),
      ],
    );
  }

  void _loadCurrentLocation() async {
    Position currentPosition = await determinePosition();
    double newLat = fetchLatitude(currentPosition);
    double newLong = fetchLongitude(currentPosition);
    String currentAddress = await reverseGeocoding(newLat, newLong);
    LatLng currentLocation = LatLng(newLat, newLong);
    controller.center = currentLocation;

    setState(() {
      location = currentLocation;
      address = currentAddress;
    });

    _saveNewMarker(LatLng(newLat, newLong));
  }

  void _gotoDefault() {
    _saveNewMarker(location!);
  }

  void _saveNewMarker(LatLng position) {
    setState(() {
      markers = [position];
      controller.center = position;
    });
  }
}
