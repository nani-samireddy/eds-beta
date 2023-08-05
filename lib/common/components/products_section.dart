import 'package:eds_beta/common/components/product_card.dart';
import 'package:eds_beta/common/components/product_page/product_page.dart';
import 'package:eds_beta/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: TextStyle(
                fontSize: 20,
                fontFamily: GoogleFonts.dmSans().fontFamily,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14.0,
                mainAxisSpacing: 14.0,
                mainAxisExtent: 300),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProductPage(
                        product: widget.products[index],
                      ),
                    ),
                  );
                },
                child: ProductCard(
                  product: widget.products[index],
                ),
              );
            },
            itemCount: widget.products.length,
          ),
        ],
      ),
    );
  }
}
