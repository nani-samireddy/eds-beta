import 'package:eds_beta/models/app_models.dart';

class CartItemDatabaseModel {
  final String productId;
  late final int quantity;
  final String size;
  CartItemDatabaseModel({
    required this.productId,
    required this.quantity,
    required this.size,
  });

  set setQuantity(int value) => quantity = value;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
      'quantity': quantity,
      'size': size,
    };
  }

  factory CartItemDatabaseModel.fromMap(Map<String, dynamic> map) {
    return CartItemDatabaseModel(
      productId: map['productId'] as String,
      quantity: map['quantity'] as int,
      size: map['size'] as String,
    );
  }

  factory CartItemDatabaseModel.fromCartItemModel(CartItemModel cartItem) {
    return CartItemDatabaseModel(
      productId: cartItem.productId,
      quantity: cartItem.quantity,
      size: cartItem.size?.size ?? "",
    );
  }

  @override
  String toString() =>
      'cartItemDatabaseModel(productId: $productId, quantity: $quantity, size: $size)';
}

class CartItemModel {
  final String productId;
  int quantity;
  final ProductModel product;
  final SizeModel? size;
  CartItemModel({
    required this.productId,
    required this.quantity,
    required this.product,
    required this.size,
  });

  set setQuantity(int value) => quantity = value;

  CartItemDatabaseModel toCartItemDatabaseModel() {
    return CartItemDatabaseModel(
      productId: productId,
      quantity: quantity,
      size: size?.size ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
      'quantity': quantity,
      'product': product.toMap(),
      'size': size?.toMap(),
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      productId: map['productId'] as String,
      quantity: map['quantity'] as int,
      product: ProductModel.fromMap(
          map: map['product'] as Map<String, dynamic>,
          productId: map['productId'] as String),
      size: SizeModel.fromMap(map['size'] as Map<String, dynamic>),
    );
  }

  @override
  String toString() =>
      'CartItemModel(productId: $productId, quantity: $quantity, product: $product, size: $size)';
}
