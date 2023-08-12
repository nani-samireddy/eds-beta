import 'package:firebase_auth/firebase_auth.dart';
import 'package:eds_beta/models/app_models.dart';


class UserModel {
  final String name;
  final String email;
  final String phone;
  final List<CartItemModel> cartItems;
  final List<WishlistItemModel> wishListItems;
  final String uid;
  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.cartItems,
    required this.wishListItems,
    required this.uid,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    List<CartItemModel>? cartItems,
    List<WishlistItemModel>? wishListItems,
    String? uid,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      cartItems: cartItems ?? this.cartItems,
      wishListItems: wishListItems ?? this.wishListItems,
      uid: uid ?? this.uid,
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
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String,
      cartItems: List<CartItemModel>.from(
          (map['cartItems'] as List).map((x) => CartItemModel.fromMap(x))),
      wishListItems: List<WishlistItemModel>.from((map['wishListItems'] as List)
          .map((x) => WishlistItemModel.fromMap(x))),
      uid: map['uid'] as String,
    );
  }

  factory UserModel.fromFirebaseUser({required User user}) {
    return UserModel(
        name: user.displayName as String,
        email: user.email as String,
        phone: user.phoneNumber as String,
        cartItems: [],
        wishListItems: [],
        uid: user.uid);
  }

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, phone: $phone, uid: $uid, cartItems: $cartItems, wishListItems: $wishListItems)';
  }

  

}
