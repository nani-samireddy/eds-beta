import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:eds_beta/models/size_model.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProductModel {
  final String productId;
  final String name;
  final String description;
  final String actualPrice;
  final String currentPrice;
  final int availableStock;
  final String? color;
  final String? brand;
  final List<SizeModel>? sizes;
  final List<String> availableColors;
  final List<String> images;
  final List<String> tags;
  final String category;
  final String manufacturer;
  final int netQuantity;
  final String details;
  final bool hasDifferentSizes;
  final Timestamp createdAt;
  ProductModel({
    required this.productId,
    required this.name,
    required this.description,
    required this.actualPrice,
    required this.currentPrice,
    required this.availableStock,
    required this.color,
    required this.sizes,
    required this.brand,
    required this.availableColors,
    required this.images,
    required this.tags,
    required this.category,
    required this.manufacturer,
    required this.netQuantity,
    required this.details,
    required this.createdAt,
  }) : hasDifferentSizes = sizes != null && sizes.isNotEmpty;

  factory ProductModel.fromMap(
      {required Map<String, dynamic> map, required String productId}) {
    return ProductModel(
      productId: productId,
      name: map['name'],
      description: map['description'],
      actualPrice: map['actualPrice'],
      currentPrice: map['currentPrice'],
      availableStock: map['availableStock'],
      color: map['color'],
      sizes: map['sizes'] != null
          ? List<SizeModel>.from(map['sizes'].map((x) => SizeModel.fromMap(x)))
          : null,
      brand: map['brand'],
      availableColors: List<String>.from(map['availableColors'] ?? []),
      images: List<String>.from(map['images']),
      tags: List<String>.from(map['tags']),
      category: map['category'],
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
      'actualPrice': actualPrice,
      'currentPrice': currentPrice,
      'availableStock': availableStock,
      'color': color,
      'brand': brand,
      'sizes': sizes?.map((e) => e.toMap()).toList(),
      'availableColors': availableColors,
      'images': images,
      'tags': tags,
      'category': category,
      'manufacturer': manufacturer,
      'netQuantity': netQuantity,
      'details': details,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return 'ProductModel(productId: $productId, name: $name, description: $description, actualPrice: $actualPrice, currentPrice: $currentPrice, availableStock: $availableStock, color: $color, brand: $brand, sizes: ${sizes!.map((e) => e.toString)}, availableColors: $availableColors, images: $images, tags: $tags, category: $category, manufacturer: $manufacturer, netQuantity: $netQuantity, details: $details, hasDifferentSizes: $hasDifferentSizes, createdAt: $createdAt)';
  }

  SizeModel getLeastPrice() {
    var temp = sizes!.where((element) => element.stock > 0).toList();
    temp.sort((a, b) => int.parse(a.price).compareTo(int.parse(b.price)));
    return temp.first;
  }
}
