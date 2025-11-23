import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_widget.dart';

class GoogleMapAdapter extends MapWidget {
  const GoogleMapAdapter({
    Key? key,
    required super.initialCenter,
    super.initialZoom = 13.0,
    super.onMapCreated,
    super.markers = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(initialCenter.latitude, initialCenter.longitude),
        zoom: initialZoom,
      ),
      onMapCreated: (controller) {
        onMapCreated?.call();
      },
      markers: markers.map((m) => Marker(
        markerId: MarkerId(m.id),
        position: LatLng(m.position.latitude, m.position.longitude),
        rotation: m.rotation,
        // icon: BitmapDescriptor.defaultMarker, // Placeholder for custom icon
      )).toSet(),
      myLocationEnabled: true,
      zoomControlsEnabled: false,
    );
  }
}
