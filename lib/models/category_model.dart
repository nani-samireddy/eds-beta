class CategoryModel {
  final String name;
  final String imageURL;
  final String id;
  final List<String> tags;

  CategoryModel(
      {required this.name,
      required this.imageURL,
      required this.id,
      required this.tags});

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
        name: map['name'] as String,
        imageURL: map['imageURL'] as String,
        id: map['id'] as String,
        tags: (map['tags'] as List).map((e) => e as String).toList());
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'image': imageURL, 'id': id, 'tags': tags};
  }
}
