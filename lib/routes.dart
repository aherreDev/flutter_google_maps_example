import 'package:flutter/material.dart';
import 'package:flutter_google_maps_example/views/index.dart';

Map<String, Widget Function(BuildContext)> appRoutes = {
  '/': (BuildContext context) => const IndexView(),
};
