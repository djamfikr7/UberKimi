class Vehicle {
  final String id;
  final double lat;
  final double lng;
  final double heading;
  final String type;
  final String driverId;

  Vehicle({
    required this.id,
    required this.lat,
    required this.lng,
    required this.heading,
    required this.type,
    required this.driverId,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      heading: (json['heading'] as num).toDouble(),
      type: json['type'] as String,
      driverId: json['driverId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lat': lat,
      'lng': lng,
      'heading': heading,
      'type': type,
      'driverId': driverId,
    };
  }
}
