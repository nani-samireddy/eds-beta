import 'package:eds_beta/core/utils.dart';
import 'package:eds_beta/models/product_model.dart';
import 'package:eds_beta/models/size_model.dart';
import 'package:eds_beta/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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
      actualPrice = widget.product.actualPrice.toString();
      discountPercentage = calculateDiscount(
        actualPrice: double.parse(actualPrice),
        currentPrice: double.parse(currentPrice),
      ).toString();
    } else {
      currentPrice = widget.product.currentPrice;
      actualPrice = widget.product.actualPrice;
      discountPercentage = calculateDiscount(
        actualPrice: double.parse(actualPrice),
        currentPrice: double.parse(currentPrice),
      ).toString();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Pallete.whiteAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
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
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name.padRight(20, " ").substring(0, 20),
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: Pallete.black),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.product.description
                        .padRight(40, " ")
                        .substring(0, 30),
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
    );
  }
}
