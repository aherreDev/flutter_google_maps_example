import 'package:flutter/material.dart';
import 'package:flutter_google_maps_example/widgets/address_form.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:latlng/latlng.dart';

import '../utils/gps_utils.dart';
import 'lat_lng_form.dart';

class LocationForm extends StatefulWidget {
  const LocationForm(
      {Key? key,
      required this.handleNewMarker,
      this.currentLocation,
      this.currentAddress})
      : super(key: key);

  final Function handleNewMarker;
  final LatLng? currentLocation;
  final String? currentAddress;

  @override
  State<LocationForm> createState() => _LocationFormState();
}

class _LocationFormState extends State<LocationForm> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            ToggleSwitch(
              initialLabelIndex: currentIndex,
              totalSwitches: 2,
              cornerRadius: 20.0,
              minWidth: double.infinity,
              labels: const ['Use LatLng', 'Use Direction'],
              onToggle: (index) {
                setState(() {
                  currentIndex = index ?? 0;
                });
              },
            ),
            currentIndex == 0
                ? AddressContainer(
                    handleNewMarker: widget.handleNewMarker,
                    currentLocation: widget.currentLocation)
                : LatLngcontainer(
                    handleNewMarker: widget.handleNewMarker,
                    currentAddress: widget.currentAddress),
          ],
        ));
  }
}

class AddressContainer extends StatefulWidget {
  const AddressContainer(
      {Key? key, required this.handleNewMarker, this.currentLocation})
      : super(key: key);

  final Function handleNewMarker;
  final LatLng? currentLocation;

  @override
  State<AddressContainer> createState() => _AddressContainerState();
}

class _AddressContainerState extends State<AddressContainer> {
  String? newAddress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LatLngForm(
          onSearch: _onSearch,
          currentLocation: widget.currentLocation,
        ),
        Text('Address found: $newAddress')
      ],
    );
  }

  void _onSearch(LatLng newLocation) async {
    String? newAddressLocation =
        await reverseGeocoding(newLocation.latitude, newLocation.longitude);

    if (newAddressLocation == null) {
      setState(() {
        newAddress = null;
      });
      return showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text('LatLng not found :('),
        ),
      );
    }

    setState(() {
      newAddress = newAddressLocation;
    });
    widget.handleNewMarker(newLocation);
  }
}

class LatLngcontainer extends StatefulWidget {
  const LatLngcontainer(
      {Key? key, required this.handleNewMarker, this.currentAddress})
      : super(key: key);

  final Function handleNewMarker;
  final String? currentAddress;

  @override
  State<LatLngcontainer> createState() => _LatLngcontainerState();
}

class _LatLngcontainerState extends State<LatLngcontainer> {
  LatLng? newLatLng;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AddressForm(onSearch: _onSearch, currentAddress: widget.currentAddress),
        Text(
          'Lat & Long found: ${newLatLng?.latitude.toString() ?? ''} , ${newLatLng?.longitude.toString()}',
        ),
      ],
    );
  }

  void _onSearch(String address) async {
    LatLng? newLocation = await geocodingByAddress(address);

    if (newLocation == null) {
      setState(() {
        newLatLng = null;
      });
      return showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text('Address not found :('),
        ),
      );
    }

    setState(() {
      newLatLng = newLocation;
    });
    widget.handleNewMarker(newLocation);
  }
}
