class ItemList {
  final int id;
  final String name;
  final String picture;
  final String description;

  ItemList({
    required this.id,
    required this.name,
    required this.picture,
    required this.description,
  });

  factory ItemList.fromJson(Map<String, dynamic> json) {
    return ItemList(
      id: json['id'] as int,
      name: json['name'] as String,
      picture: json['picture'] as String,
      description: json['description'] as String,
    );
  }
}