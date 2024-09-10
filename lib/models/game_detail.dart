class GameDetail {
  final String id;
  final String name;
  final String image;
  final String type;
  final bool allowItemExchange;
  final String instructions;
  final bool active;

  GameDetail({
    required this.id,
    required this.name,
    required this.image,
    required this.type,
    required this.allowItemExchange,
    required this.instructions,
    required this.active,
  });

  factory GameDetail.fromJson(Map<String, dynamic> json) {
    return GameDetail(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      type: json['type'],
      allowItemExchange: json['allowItemExchange'],
      instructions: json['instructions'],
      active: json['active'],
    );
  }
}