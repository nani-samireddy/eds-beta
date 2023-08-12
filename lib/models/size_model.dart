// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SizeModel {
  final String size;
  final int stock;
  final String price;
  final String actualPrice;
  SizeModel({
    required this.size,
    required this.stock,
    required this.price,
    required this.actualPrice,
  });

  SizeModel copyWith({
    String? size,
    int? stock,
    String? price,
    String? actualPrice,
  }) {
    return SizeModel(
      size: size ?? this.size,
      stock: stock ?? this.stock,
      price: price ?? this.price,
      actualPrice: actualPrice ?? this.actualPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'size': size,
      'stock': stock,
      'price': price,
      'actualPrice': actualPrice,
    };
  }

  factory SizeModel.fromMap(Map<String, dynamic> map) {
    return SizeModel(
      size: map['size'] as String,
      stock: map['stock'] as int,
      price: map['price'] as String,
      actualPrice: map['actualPrice'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SizeModel.fromJson(String source) =>
      SizeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SizeModel(size: $size, stock: $stock, price: $price, actualPrice: $actualPrice)';

  @override
  bool operator ==(covariant SizeModel other) {
    if (identical(this, other)) return true;

    return other.size == size &&
        other.stock == stock &&
        other.price == price &&
        other.actualPrice == actualPrice;
  }

  @override
  int get hashCode {
    return size.hashCode ^
        stock.hashCode ^
        price.hashCode ^
        actualPrice.hashCode;
  }
}
