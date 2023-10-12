import 'package:eds_beta/common/components/product_card.dart';
import 'package:eds_beta/core/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eds_beta/models/app_models.dart';

class ProductsSection extends ConsumerStatefulWidget {
  const ProductsSection(
      {super.key, required this.title, required this.products});
  final String title;
  final List<ProductModel> products;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductsSectionState();
}

class _ProductsSectionState extends ConsumerState<ProductsSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Text(widget.title, style: AppStyles.sectionHeading),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              mainAxisExtent: 250),
          itemBuilder: (context, index) {
            return ProductCard(
              product: widget.products[index],
            );
          },
          itemCount: widget.products.length,
        ),
      ],
    );
  }
}
