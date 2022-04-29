import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';

class LatLngForm extends StatefulWidget {
  LatLngForm({Key? key, required this.onSearch, this.currentLocation})
      : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey();
  final onSearch;
  final LatLng? currentLocation;

  @override
  State<LatLngForm> createState() => _LatLngFormState();
}

class _LatLngFormState extends State<LatLngForm> {
  late final TextEditingController _latController;
  late final TextEditingController _longController;

  @override
  void initState() {
    super.initState();
    _latController = TextEditingController(
        text: widget.currentLocation?.latitude.toString() ?? '');
    _longController = TextEditingController(
        text: widget.currentLocation?.longitude.toString() ?? '');
  }

  @override
  void dispose() {
    _latController.dispose();
    _longController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Latitude'),
            validator: fieldValidation,
            controller: _latController,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Longitude'),
            validator: fieldValidation,
            controller: _longController,
          ),
          ElevatedButton(
            onPressed: () {
              final form = widget._formKey.currentState;
              if (form!.validate()) _submitForm();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Search'),
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.search)
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? fieldValidation(value) {
    if (value != null && value.isEmpty) {
      return 'Please enter your first name.';
    }

    return null;
  }

  void _submitForm() {
    LatLng newLocation = LatLng(
        double.parse(_latController.text), double.parse(_longController.text));

    widget.onSearch(newLocation);
  }
}
