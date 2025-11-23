import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'map_widget.dart';

class OpenStreetMapAdapter extends MapWidget {
  const OpenStreetMapAdapter({
    Key? key,
    required LatLng initialCenter,
    double initialZoom = 13.0,
    VoidCallback? onMapCreated,
    List<MapMarker> markers = const [],
  }) : super(
          key: key,
          initialCenter: initialCenter,
          initialZoom: initialZoom,
          onMapCreated: onMapCreated,
          markers: markers,
        );

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: initialCenter,
        initialZoom: initialZoom,
        onMapReady: onMapCreated,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.uberkimi.mapsdk',
        ),
        MarkerLayer(
          markers: markers.map((m) => Marker(
            point: m.position,
            width: 40,
            height: 40,
            child: Transform.rotate(
              angle: m.rotation * (3.14159 / 180), // Convert degrees to radians
              child: const Icon(Icons.directions_car, color: Colors.black, size: 30),
            ),
          )).toList(),
        ),
      ],
    );
  }
}
