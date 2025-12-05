class ActionCard {
  final String type;
  final int priority;
  final Map<String, dynamic> data;

  ActionCard({required this.type, required this.priority, required this.data});

  factory ActionCard.fromJson(Map<String, dynamic> json) {
    return ActionCard(
      type: json['type'] as String,
      priority: json['priority'] as int,
      data: json['data'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'priority': priority, 'data': data};
  }
}
