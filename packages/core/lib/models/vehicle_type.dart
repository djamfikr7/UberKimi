class VehicleType {
  final String id;
  final String name;
  final int etaMinutes;
  final double baseFare;
  final double surgeMultiplier;
  final String iconUrl;

  VehicleType({
    required this.id,
    required this.name,
    required this.etaMinutes,
    required this.baseFare,
    required this.surgeMultiplier,
    required this.iconUrl,
  });

  factory VehicleType.fromJson(Map<String, dynamic> json) {
    return VehicleType(
      id: json['id'] as String,
      name: json['name'] as String,
      etaMinutes: json['etaMinutes'] as int,
      baseFare: (json['baseFare'] as num).toDouble(),
      surgeMultiplier: (json['surgeMultiplier'] as num).toDouble(),
      iconUrl: json['iconUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'etaMinutes': etaMinutes,
      'baseFare': baseFare,
      'surgeMultiplier': surgeMultiplier,
      'iconUrl': iconUrl,
    };
  }
}
