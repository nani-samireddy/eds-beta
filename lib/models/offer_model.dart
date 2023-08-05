import 'dart:convert';

class Offer {
  final String name;
  final String description;
  final String image;
  
  Offer({
    required this.name,
    required this.description,
    required this.image,
  });

  Offer copyWith({
    String? name,
    String? description,
    String? image,
  }) {
    return Offer(
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'image': image,
    };
  }

  factory Offer.fromMap(Map<String, dynamic> map) {
    return Offer(
      name: map['name'] as String,
      description: map['description'] as String,
      image: map['image'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Offer.fromJson(String source) => Offer.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Offer(name: $name, description: $description, image: $image)';

  @override
  bool operator ==(covariant Offer other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.description == description &&
      other.image == image;
  }

}
