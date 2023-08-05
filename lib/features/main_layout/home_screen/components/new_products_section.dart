import 'package:eds_beta/api/database_api.dart';
import 'package:eds_beta/common/components/products_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewProducts extends ConsumerStatefulWidget {
  const NewProducts({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewProductsState();
}

class _NewProductsState extends ConsumerState<NewProducts> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final latestProducts = ref.watch(latestProductsProvider);
        return latestProducts.when(
          data: (products) {
            return ProductsSection(
                title: "Latest Products", products: products!);
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => const Center(
            child: Text("Error"),
          ),
        );
      },
    );
  }
}
