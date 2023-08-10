class CartItemModel {
  final String productId;
  int quantity;
  CartItemModel({
    required this.productId,
    required this.quantity,
  });

  set setQuantity(int value) => quantity = value;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      productId: map['productId'] as String,
      quantity: map['quantity'] as int,
    );
  }
}
