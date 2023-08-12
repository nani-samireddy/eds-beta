class WishlistItemModel {
  final String productId;
  WishlistItemModel({
    required this.productId,
  });

  WishlistItemModel copyWith({
    String? productId,
  }) {
    return WishlistItemModel(
      productId: productId ?? this.productId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
    };
  }

  factory WishlistItemModel.fromMap(Map<String, dynamic> map) {
    return WishlistItemModel(
      productId: map['productId'],
    );
  }

  @override
  String toString() => 'WishlistItemModel(productId: $productId)';
}
