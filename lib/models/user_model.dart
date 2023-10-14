import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:eds_beta/models/app_models.dart';

class UserModel {
  final String name;
  final String email;
  final String phone;
  final List<CartItemDatabaseModel> cartItems;
  final List<WishlistItemModel> wishListItems;
  final String uid;
  final List<AddressModel> addresses;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.cartItems,
    required this.wishListItems,
    required this.uid,
    required this.addresses,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    List<CartItemDatabaseModel>? cartItems,
    List<WishlistItemModel>? wishListItems,
    String? uid,
    List<AddressModel>? addresses,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      cartItems: cartItems ?? this.cartItems,
      wishListItems: wishListItems ?? this.wishListItems,
      uid: uid ?? this.uid,
      addresses: addresses ?? this.addresses,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'phone': phone,
      'cartItems': cartItems.map((e) => e.toMap()).toList(),
      'wishListItems': wishListItems.map((e) => e.toMap()).toList(),
      'uid': uid,
      'addresses': addresses.map((e) => e.toMap()).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final user = UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      cartItems: List<CartItemDatabaseModel>.from((map['cartItems'] as List)
          .map((x) => CartItemDatabaseModel.fromMap(x))),
      wishListItems: List<WishlistItemModel>.from((map['wishListItems'] as List)
          .map((x) => WishlistItemModel.fromMap(x))),
      uid: map['uid'] as String,
      addresses: List<AddressModel>.from(
          (map['addresses'] as List).map((x) => AddressModel.fromMap(x))),
    );
    log("User from map: $user");
    return user;
  }

  factory UserModel.fromFirebaseUser({required User user}) {
    return UserModel(
        name: user.displayName as String,
        email: user.email as String,
        phone: user.phoneNumber as String,
        cartItems: [],
        wishListItems: [],
        uid: user.uid,
        addresses: []);
  }

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, phone: $phone, uid: $uid, cartItems: $cartItems, wishListItems: $wishListItems, addresses: $addresses)';
  }
}
