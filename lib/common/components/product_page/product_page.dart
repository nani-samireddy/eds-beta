import 'dart:developer';
import 'package:eds_beta/api/cart_api.dart';
import 'package:eds_beta/api/wishlist_api.dart';
import 'package:eds_beta/common/components/product_images_slider.dart';
import 'package:eds_beta/common/components/product_page/product_details_table.dart';
import 'package:eds_beta/common/components/product_page/similar_products.dart';
import 'package:eds_beta/core/styles.dart';
import 'package:eds_beta/core/utils.dart';
import 'package:eds_beta/features/main_layout/cart/view/cart_view.dart';
import 'package:eds_beta/models/app_models.dart';
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
  late SizeModel? selectedSize;
  late String currentPrice, actualPrice, discountPercentage;
  late List<ProductModel> relatedProducts;
  bool isInCart = false;
  bool isInWishlist = false;
  @override
  void initState() {
    log("hiiii");
    if (widget.product.hasDifferentSizes) {
      selectedSize = widget.product.getLeastPrice();
      currentPrice = selectedSize!.price.toString();
      actualPrice = selectedSize!.actualPrice.toString();
      discountPercentage = calculateDiscount(
              actualPrice: double.parse(actualPrice),
              currentPrice: double.parse(currentPrice))
          .toString();
    } else {
      selectedSize = null;
      currentPrice = widget.product.currentPrice;
      actualPrice = widget.product.actualPrice;
      discountPercentage = calculateDiscount(
              actualPrice: double.parse(actualPrice),
              currentPrice: double.parse(currentPrice))
          .toString();
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      isInCart = ref.watch(cartAPIProvider).isItemInCart(
          productId: widget.product.productId, size: selectedSize);
      isInWishlist = ref
          .watch(wishlistAPIProvider.notifier)
          .isItemInWishlist(productId: widget.product.productId);
    });
    super.didChangeDependencies();
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
      // check if the product is in cart
      isInCart = ref.watch(cartAPIProvider).isItemInCart(
          productId: widget.product.productId, size: selectedSize);
      log("selected size: ${size.size} price: $currentPrice");
    });
  }

  void handleAddToCart() {
    ref.watch(cartAPIProvider).addCartItem(
        cartItem: CartItemDatabaseModel(
            productId: widget.product.productId,
            quantity: 1,
            size: selectedSize!.size));
    setState(() {
      isInCart = true;
    });
  }

  void handleCheckout() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const CartView()));
  }

  void handleAddToWishlist() {
    if (isInWishlist) {
      ref.watch(wishlistAPIProvider.notifier).removeWishlistItem(
          wishlistItem: WishlistItemModel(productId: widget.product.productId));
    } else {
      ref.watch(wishlistAPIProvider.notifier).addWishlistItem(
          wishlistItem: WishlistItemModel(productId: widget.product.productId));
    }
    setState(() {
      isInWishlist = !isInWishlist;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.product.name,
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontFamily: GoogleFonts.poppins().fontFamily),
        ),
        actions: [
          IconButton(
            onPressed: () {
              //TODO: Share Product
            },
            icon: const Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              color: Pallete.backgroundColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ///
                  /// Product Slider and price section
                  ///
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProductImagesSlider(images: widget.product.images),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.product.name,
                                  style: AppStyles.sectionHeading
                                      .copyWith(fontSize: 22),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  widget.product.tagline,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Pallete.textBlackColor,
                                      fontSize: 14,
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily),
                                ),
                              ],
                            ),
                            IconButton(
                                iconSize: 30,
                                isSelected: isInWishlist,
                                highlightColor: Pallete.black,
                                selectedIcon: const Icon(
                                  Icons.favorite,
                                  color: Pallete.black,
                                ),
                                onPressed: handleAddToWishlist,
                                icon: isInWishlist
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Pallete.primaryButtonShadowColor,
                                      )
                                    : const Icon(
                                        Icons.favorite_border_outlined))
                          ],
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
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: GoogleFonts.dmSans().fontFamily,
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Size",
                                style: AppStyles.sectionHeading,
                              ),
                              const SizedBox(height: 10),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    children: widget.product.sizes?.map((size) {
                                          return size.stock > 0
                                              ? GestureDetector(
                                                  onTap: () {
                                                    changeSelectedSize(size);
                                                  },
                                                  child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 10,
                                                            bottom: 10),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 10,
                                                        horizontal: 18),
                                                    decoration: BoxDecoration(
                                                      color: selectedSize ==
                                                              size
                                                          ? Pallete.black
                                                          : Pallete
                                                              .backgroundColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    child: Text(
                                                      size.size,
                                                      style: TextStyle(
                                                          color: selectedSize ==
                                                                  size
                                                              ? Pallete.white
                                                              : Pallete
                                                                  .textBlackColor,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily:
                                                              GoogleFonts
                                                                      .dmSans()
                                                                  .fontFamily),
                                                    ),
                                                  ),
                                                )
                                              : const SizedBox.shrink();
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Details",
                          style: AppStyles.sectionSubheading,
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
                        ProductDetailsTable(details: widget.product.details)
                      ],
                    ),
                  ),

                  ///
                  /// Related Products Section
                  ///
                  SimilarProducts(
                    product: widget.product,
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          ///
          /// Add to cart button
          ///
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              height: 80,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Pallete.primaryButtonShadowColor,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                  ),
                ),
                onPressed: isInCart ? handleCheckout : handleAddToCart,
                child: Center(
                    child: Text(
                  isInCart ? "GOTO CART" : "ADD TO CART",
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Pallete.black,
                      fontSize: 22,
                      fontFamily: GoogleFonts.unbounded().fontFamily),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
