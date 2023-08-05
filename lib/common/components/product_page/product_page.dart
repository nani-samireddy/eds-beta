import 'dart:developer';

import 'package:eds_beta/common/components/product_images_slider.dart';
import 'package:eds_beta/common/components/product_page/product_details_table.dart';
import 'package:eds_beta/core/utils.dart';
import 'package:eds_beta/models/product_model.dart';
import 'package:eds_beta/models/size_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/theme.dart';

class ProductPage extends ConsumerStatefulWidget {
  const ProductPage({super.key, required this.product});
  final ProductModel product;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProductPageState();
}

class _ProductPageState extends ConsumerState<ProductPage> {
  late SizeModel selectedSize = widget.product.getLeastPrice();
  late String currentPrice, actualPrice, discountPercentage;
  @override
  void initState() {
    if (widget.product.hasDifferentSizes) {
      SizeModel selectedSize = widget.product.getLeastPrice();
      currentPrice = selectedSize.price.toString();
      actualPrice = widget.product.actualPrice.toString();
      discountPercentage = calculateDiscount(
              actualPrice: double.parse(actualPrice),
              currentPrice: double.parse(currentPrice))
          .toString();
    } else {
      currentPrice = widget.product.currentPrice;
      actualPrice = widget.product.actualPrice;
      discountPercentage = calculateDiscount(
              actualPrice: double.parse(actualPrice),
              currentPrice: double.parse(currentPrice))
          .toString();
    }
    super.initState();
  }

  void changeSelectedSize(SizeModel size) {
    setState(() {
      selectedSize = size;
      currentPrice = size.price.toString();
      actualPrice = size.actualPrice.toString();
      discountPercentage = calculateDiscount(
        actualPrice: double.parse(actualPrice),
        currentPrice: double.parse(currentPrice),
      ).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Pallete.backgroundColor,
          child: Column(
            children: [
              ///
              /// Product Slider and price section
              ///
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductImagesSlider(images: widget.product.images),
                    const SizedBox(height: 20),
                    Text(
                      widget.product.name,
                      style: TextStyle(
                          color: Pallete.textBlackColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          fontFamily: GoogleFonts.dmSans().fontFamily),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.product.description,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Pallete.textBlackColor,
                          fontSize: 14,
                          fontFamily: GoogleFonts.poppins().fontFamily),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: GoogleFonts.dmSans().fontFamily,
                            color: Pallete.black),
                        children: [
                          TextSpan(
                            text: "₹$currentPrice  ",
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: actualPrice,
                            style: const TextStyle(
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,
                              color: Pallete.textBlackColor,
                            ),
                          ),
                          TextSpan(
                            text: "  $discountPercentage%  ",
                            style: const TextStyle(
                              fontSize: 16,
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

              ///
              /// Prodcut Size and Color Section
              ///
              widget.product.hasDifferentSizes
                  ? Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Size",
                            style: TextStyle(
                                color: Pallete.textBlackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                fontFamily: GoogleFonts.dmSans().fontFamily),
                          ),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                children: widget.product.sizes?.map((size) {
                                      return GestureDetector(
                                        onTap: size.stock > 0
                                            ? () {
                                                changeSelectedSize(size);
                                              }
                                            : null,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              right: 10, bottom: 10),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                          decoration: BoxDecoration(
                                            color: size.stock > 0
                                                ? selectedSize == size
                                                    ? Pallete
                                                        .bottomNavActiveColor
                                                    : Pallete.backgroundColor
                                                : Pallete.fadedIconColor
                                                    .withOpacity(.2),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            size.size,
                                            style: TextStyle(
                                                color: size.stock > 0
                                                    ? selectedSize == size
                                                        ? Pallete.white
                                                        : Pallete.textBlackColor
                                                    : Pallete.fadedIconColor
                                                        .withOpacity(.4),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: GoogleFonts.dmSans()
                                                    .fontFamily),
                                          ),
                                        ),
                                      );
                                    }).toList() ??
                                    []),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),

              ///
              /// Description Section
              ///
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                margin: const EdgeInsets.only(top: 12),
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Details",
                      style: TextStyle(
                          color: Pallete.textBlackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          fontFamily: GoogleFonts.dmSans().fontFamily),
                    ),
                    const SizedBox(height: 10),
                    ProductDetailsTable(details: widget.product.details)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
