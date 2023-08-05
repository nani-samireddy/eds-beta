class ProductPreviewModel {
  final String productId;
  final String name;
  final double actualPrice;
  final double discountPrice;

  ProductPreviewModel({
    required this.productId,
    required this.name,
    required this.actualPrice,
    required this.discountPrice,
  });

  factory ProductPreviewModel.fromMap(Map<String, dynamic> map) {
    return ProductPreviewModel(
      productId: map['productId'],
      name: map['name'],
      actualPrice: map['actualPrice'],
      discountPrice: map['discountPrice'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'actualPrice': actualPrice,
      'discountPrice': discountPrice,
    };
  }
}
