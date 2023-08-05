import 'dart:convert';

class SectionItemModel {
  final String name;
  final String imageURL;
  final List<String> tags;
  final String category;
  SectionItemModel({
    required this.name,
    required this.imageURL,
    required this.tags,
    required this.category,
  });

  SectionItemModel copyWith({
    String? name,
    String? imageURL,
    List<String>? tags,
    String? category,
  }) {
    return SectionItemModel(
      name: name ?? this.name,
      imageURL: imageURL ?? this.imageURL,
      tags: tags ?? this.tags,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'imageURL': imageURL,
      'tags': tags,
      'category': category,
    };
  }

  factory SectionItemModel.fromMap(Map<String, dynamic> map) {
    return SectionItemModel(
      name: map['name'] as String,
      imageURL: map['imageURL'] as String,
      tags: List<String>.from((map['tags'] as List<String>)),
      category: map['category'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SectionItemModel.fromJson(String source) =>
      SectionItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SectionItemModel(name: $name, imageURL: $imageURL, tags: $tags, category: $category)';
  }
}
