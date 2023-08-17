import 'package:eds_beta/core/utils.dart';
import 'package:eds_beta/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/app_models.dart';
import 'product_page/product_page.dart';

class ProductCard extends ConsumerStatefulWidget {
  const ProductCard({
    super.key,
    required this.product,
  });
  final ProductModel product;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  late String currentPrice, actualPrice, discountPercentage;
  @override
  void initState() {
    if (widget.product.hasDifferentSizes) {
      SizeModel cheapestModel = widget.product.getLeastPrice();
      currentPrice = cheapestModel.price.toString();
      actualPrice = cheapestModel.actualPrice.toString();
    } else {
      currentPrice = widget.product.currentPrice;
      actualPrice = widget.product.actualPrice;
    }
    discountPercentage = widget.product.getDiscount.toString();
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductPage(
              product: widget.product,
            ),
          ),
        );
      },
      child: Container(
        width: 180,
        height: 300,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Pallete.whiteAccent,
          borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Pallete.blue.withOpacity(0.1),
                blurRadius: 18,
                offset: const Offset(0, 5),
              )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.product.images[0],
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name.padRight(20, " ").substring(0, 10),
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          color: Pallete.black),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.product.tagline.padRight(40, " ").substring(0, 20),
                      softWrap: true,
                      style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Pallete.textBlackColor),
                    ),
                    const SizedBox(height: 2),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                            fontFamily: GoogleFonts.dmSans().fontFamily,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Pallete.black),
                        children: [
                          TextSpan(
                            text: "₹$currentPrice  ",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: actualPrice,
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Pallete.textBlackColor,
                            ),
                          ),
                          TextSpan(
                            text: "   $discountPercentage%  ",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 87, 137, 28),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
