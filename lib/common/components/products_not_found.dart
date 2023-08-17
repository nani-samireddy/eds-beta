import 'package:flutter/material.dart';

class ProductsNotFound extends StatelessWidget {
  const ProductsNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('No products found'),
      ),
    );
  }
}
