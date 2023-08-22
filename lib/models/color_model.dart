// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ColorModel {
  final String color;
  final String productId;
  ColorModel({
    required this.color,
    required this.productId,
  });


  ColorModel copyWith({
    String? color,
    String? productId,
  }) {
    return ColorModel(
      color: color ?? this.color,
      productId: productId ?? this.productId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'color': color,
      'productId': productId,
    };
  }

  factory ColorModel.fromMap(Map<String, dynamic> map) {
    return ColorModel(
      color: map['color'] as String,
      productId: map['productId'] as String,
    );
  }


  String get getColor => color;
  String toJson() => json.encode(toMap());

  factory ColorModel.fromJson(String source) => ColorModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ColorModel(color: $color, productId: $productId)';

  @override
  bool operator ==(covariant ColorModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.color == color &&
      other.productId == productId;
  }

  @override
  int get hashCode => color.hashCode ^ productId.hashCode;
}
