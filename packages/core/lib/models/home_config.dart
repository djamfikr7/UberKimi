import 'vehicle_type.dart';
import 'action_card.dart';

class HomeConfig {
  final Map<String, bool> featureFlags;
  final List<VehicleType> vehicleTypes;
  final List<ActionCard> actionCards;

  HomeConfig({
    required this.featureFlags,
    required this.vehicleTypes,
    required this.actionCards,
  });

  factory HomeConfig.fromJson(Map<String, dynamic> json) {
    return HomeConfig(
      featureFlags: Map<String, bool>.from(json['featureFlags'] as Map),
      vehicleTypes: (json['vehicleTypes'] as List)
          .map((e) => VehicleType.fromJson(e))
          .toList(),
      actionCards: (json['actionCards'] as List)
          .map((e) => ActionCard.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'featureFlags': featureFlags,
      'vehicleTypes': vehicleTypes.map((e) => e.toJson()).toList(),
      'actionCards': actionCards.map((e) => e.toJson()).toList(),
    };
  }
}
