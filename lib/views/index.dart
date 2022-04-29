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
  double long = 0.0;
  double lat = 0.0;
  String location = 'Index';
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
      body: Column(
        children: [
          LocationForm(handleNewMarker: _saveNewMarker),
          MapWidget(controller: controller, markers: markers),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _gotoDefault,
        tooltip: 'My Location',
        child: const Icon(Icons.my_location),
      ),
    );
  }

  String _latLongStr() {
    return '$lat, $long';
  }

  void _loadCurrentLocation() async {
    Position currentPosition = await determinePosition();
    lat = fetchLatitude(currentPosition);
    long = fetchLongitude(currentPosition);
    String currentAddress = await reverseGeocoding(lat, long);
    controller.center = LatLng(lat, long);

    setState(() {
      location = currentAddress;
    });
  }

  void _gotoDefault() {
    LatLng position = LatLng(lat, long);

    _saveNewMarker(position);
  }

  void _saveNewMarker(LatLng position) {
    setState(() {
      markers = [position];
      controller.center = position;
    });
  }
}
