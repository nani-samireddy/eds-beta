import 'dart:developer';
import 'package:eds_beta/common/components/product_card.dart';
import 'package:eds_beta/core/styles.dart';
import 'package:eds_beta/providers/database_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eds_beta/models/app_models.dart';

class SimilarProducts extends ConsumerStatefulWidget {
  const SimilarProducts({super.key, required this.product});
  final ProductModel product;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SimilarProductsState();
}

class _SimilarProductsState extends ConsumerState<SimilarProducts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Similar Products",
            style: AppStyles.sectionSubheading,
          ),
          const SizedBox(height: 20),
          ref.watch(similarProductsProvider(widget.product)).when(
              data: (data) {
                if (data.isEmpty) {
                  return const Text("No similar products found");
                }
                return _buildSimilarProducts(data);
              },
              error: (error, s) {
                log("Error getting similar products: $error");
                return const Text(
                    "we are unable to get similar products at the moment");
              },
              loading: () => const Center(child: CircularProgressIndicator())),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSimilarProducts(List<ProductModel> data) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: data.isEmpty
            ? [const Text("No similar products found")]
            : data.map((e) {
          return Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: ProductCard(product: e));
        }).toList(),
      ),
    );
  }
}
