import 'package:flutter/material.dart';

class AddressForm extends StatefulWidget {
  AddressForm({Key? key, required this.onSearch, this.currentAddress})
      : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey();
  final Function onSearch;
  final String? currentAddress;

  @override
  State<AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  late final TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _addressController =
        TextEditingController(text: widget.currentAddress ?? '');
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(labelText: 'Address'),
            validator: fieldValidation,
          ),
          ElevatedButton(
            onPressed: () {
              final form = widget._formKey.currentState;
              if (form!.validate()) widget.onSearch(_addressController.text);
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
}
