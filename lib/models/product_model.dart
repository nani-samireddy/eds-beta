import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eds_beta/models/app_models.dart';
import 'package:eds_beta/models/color_model.dart';

class ProductModel {
  final String productId;
  final String name;
  final String tagline;
  final String description;
  final String actualPrice;
  final String currentPrice;
  final int availableStock;
  final String? color;
  final String? brand;
  final List<SizeModel>? sizes;
  final List<ColorModel>? availableColors;
  final bool hasDifferentColors;
  final List<String> images;
  final List<String> tags;
  final String category;
  final String type;
  final String? gender;
  final String manufacturer;
  final int netQuantity;
  final String details;
  final String rating;
  final bool hasDifferentSizes;
  final Timestamp createdAt;
  ProductModel({
    required this.productId,
    required this.name,
    required this.description,
    required this.tagline,
    required this.actualPrice,
    required this.currentPrice,
    required this.availableStock,
    required this.color,
    required this.sizes,
    required this.brand,
    required this.availableColors,
    required this.images,
    required this.rating,
    required this.tags,
    required this.category,
    required this.type,
    required this.gender,
    required this.manufacturer,
    required this.netQuantity,
    required this.details,
    required this.createdAt,
  })  : hasDifferentSizes = sizes != null && sizes.isNotEmpty,
        hasDifferentColors =
            availableColors != null && availableColors.isNotEmpty;

  factory ProductModel.fromMap(
      {required Map<String, dynamic> map, required String productId}) {
    return ProductModel(
      productId: productId,
      name: map['name'],
      description: map['description'],
      tagline: map['tagline'],
      actualPrice: map['actualPrice'],
      currentPrice: map['currentPrice'],
      availableStock: map['availableStock'],
      color: map['color'] ?? "",
      rating: map['rating'],
      sizes: map['sizes'] != null
          ? List<SizeModel>.from(map['sizes'].map((x) => SizeModel.fromMap(x)))
          : [],
      brand: map['brand'],
      availableColors:
          map['availableColors'] != null && map['availableColors'].isNotEmpty
              ? List<ColorModel>.from(
                  map['sizes'].map((x) => ColorModel.fromMap(x)))
              : [],
      images: List<String>.from(map['images']),
      tags: List<String>.from(map['tags']),
      category: map['category'],
      type: map['type'],
      gender: map['gender'],
      manufacturer: map['manufacturer'] ?? '',
      netQuantity: map['netQuantity'],
      details: map['details'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
      'name': name,
      'description': description,
      'tagline': tagline,
      'actualPrice': actualPrice,
      'currentPrice': currentPrice,
      'availableStock': availableStock,
      'color': color,
      'brand': brand,
      'sizes': sizes?.map((e) => e.toMap()).toList(),
      'availableColors': availableColors,
      'images': images,
      'tags': tags,
      'rating': rating,
      'category': category,
      'type': type,
      'gender': gender,
      'manufacturer': manufacturer,
      'netQuantity': netQuantity,
      'details': details,
      'createdAt': createdAt,
    };
  }

  

  @override
  String toString() {
    return 'ProductModel(productId: $productId,\n name: $name,\n tagline: $tagline,\n description: $description,\n actualPrice: $actualPrice,\n currentPrice: $currentPrice,\n availableStock: $availableStock,\n rating: $rating,\ncolor: $color,\n brand: $brand,\n sizes: ${sizes!},\n availableColors: $availableColors,\n images: $images,\n tags: $tags,\n category: $category,\n type: $type,\n gender: $gender,\n manufacturer: $manufacturer,\n netQuantity: $netQuantity,\n details: $details,\n hasDifferentSizes: $hasDifferentSizes,\n createdAt: $createdAt,\n)';
  }

  double get getMinPrice {
    if (sizes == null || sizes!.isEmpty) {
      return double.parse(currentPrice);
    }
    var temp = sizes!;
    temp.sort((a, b) => int.parse(a.price).compareTo(int.parse(b.price)));
    return double.parse(temp.first.price);
  }

  double get getDiscount {
    if (sizes == null || sizes!.isEmpty) {
      double ap = double.parse(actualPrice);
      double cp = double.parse(currentPrice);
      return 100 - ((cp / ap) * 100);
    }
    var temp = sizes!;
    temp.sort((a, b) => int.parse(a.price).compareTo(int.parse(b.price)));
    double ap = double.parse(temp.first.actualPrice);
    double cp = double.parse(temp.first.price);
    return 100 - ((cp / ap) * 100);
  }

  double get ratingRatio {
    return double.parse(rating) / 5;
  }

  SizeModel getLeastPrice() {
    var temp = sizes!;
    temp.sort((a, b) => int.parse(a.price).compareTo(int.parse(b.price)));
    return temp.first;
  }
}
