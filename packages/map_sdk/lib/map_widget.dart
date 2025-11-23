import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

abstract class MapWidget extends StatelessWidget {
  final LatLng initialCenter;
  final double initialZoom;
  final VoidCallback? onMapCreated;
  final List<MapMarker> markers;

  const MapWidget({
    Key? key,
    required this.initialCenter,
    this.initialZoom = 13.0,
    this.onMapCreated,
    this.markers = const [],
  }) : super(key: key);
}

class MapMarker {
  final String id;
  final LatLng position;
  final double rotation;
  final String iconPath;

  MapMarker({
    required this.id,
    required this.position,
    this.rotation = 0.0,
    this.iconPath = 'assets/car_icon.png', // Placeholder
  });
}
