import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';

class MapWidget extends StatefulWidget {
  const MapWidget(
      {Key? key,
      required this.controller,
      this.defaultLocation,
      required this.markers})
      : super(key: key);

  final MapController controller;
  final LatLng? defaultLocation;
  final List<LatLng> markers;

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  Offset? _dragStart;
  double _scaleStart = 1.0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // height: 250,
      // width: double.infinity,
      child: MapLayoutBuilder(
        controller: widget.controller,
        builder: (context, transformer) {
          final markerPositions =
              widget.markers.map(transformer.fromLatLngToXYCoords).toList();

          final markerWidgets = markerPositions.map(
            (pos) => _buildMarkerWidget(pos, Colors.red),
          );

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onDoubleTap: _onDoubleTap,
            onScaleStart: _onScaleStart,
            onScaleUpdate: _onScaleUpdate,
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  final delta = event.scrollDelta;

                  widget.controller.zoom -= delta.dy / 1000.0;
                  setState(() {});
                }
              },
              child: Stack(
                children: [
                  Map(
                    controller: widget.controller,
                    builder: (context, x, y, z) {
                      //Legal notice: This url is only used for demo and educational purposes. You need a license key for production use.
                      //Google Maps
                      final url =
                          'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';
                      return CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  ...markerWidgets,
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMarkerWidget(Offset pos, Color color,
      [IconData icon = Icons.location_on]) {
    return Positioned(
      left: pos.dx - 24,
      top: pos.dy - 24,
      width: 48,
      height: 48,
      child: GestureDetector(
        child: Icon(
          icon,
          color: color,
          size: 48,
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => const AlertDialog(
              content: Text('You have clicked a marker!'),
            ),
          );
        },
      ),
    );
  }

  void _onDoubleTap() {
    widget.controller.zoom += 0.5;
    setState(() {});
  }

  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      widget.controller.zoom += 0.02;
    } else if (scaleDiff < 0) {
      widget.controller.zoom -= 0.02;
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart!;

      _dragStart = now;
      widget.controller.drag(diff.dx, diff.dy);
    }

    setState(() {});
  }
}
