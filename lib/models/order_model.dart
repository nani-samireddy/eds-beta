// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:eds_beta/models/app_models.dart';

class OrderModel {
  final List<CartItemDatabaseModel> items;
  final AddressModel address;
  final double price;
  final double deliveryCharge;
  final double total;
  final String orderId;
  OrderModel({
    required this.items,
    required this.address,
    required this.price,
    required this.deliveryCharge,
    required this.total,
    required this.orderId,
  });

  OrderModel copyWith({
    List<CartItemDatabaseModel>? items,
    AddressModel? address,
    double? price,
    double? deliveryCharge,
    double? total,
    String? orderId,
  }) {
    return OrderModel(
      items: items ?? this.items,
      address: address ?? this.address,
      price: price ?? this.price,
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      total: total ?? this.total,
      orderId: orderId ?? this.orderId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'items': items.map((x) => x.toMap()).toList(),
      'address': address.toMap(),
      'price': price,
      'deliveryCharge': deliveryCharge,
      'total': total,
      'orderId': orderId,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      items: List<CartItemDatabaseModel>.from(
        (map['items'] as List<int>).map<CartItemDatabaseModel>(
          (x) => CartItemDatabaseModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      address: AddressModel.fromMap(map['address'] as Map<String, dynamic>),
      price: map['price'] as double,
      deliveryCharge: map['deliveryCharge'] as double,
      total: map['total'] as double,
      orderId: map['orderId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderModel(items: $items, address: $address, price: $price, deliveryCharge: $deliveryCharge, total: $total, orderId: $orderId)';
  }

  @override
  bool operator ==(covariant OrderModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.items, items) &&
        other.address == address &&
        other.price == price &&
        other.deliveryCharge == deliveryCharge &&
        other.total == total &&
        other.orderId == orderId;
  }

  @override
  int get hashCode {
    return items.hashCode ^
        address.hashCode ^
        price.hashCode ^
        deliveryCharge.hashCode ^
        total.hashCode ^
        orderId.hashCode;
  }
}
