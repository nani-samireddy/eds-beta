import 'dart:developer';

import 'package:eds_beta/api/cart_api.dart';
import 'package:eds_beta/common/circular_loading_page.dart';
import 'package:eds_beta/common/components/cart_item_card.dart';
import 'package:eds_beta/common/primary_button.dart';
import 'package:eds_beta/constants/constans.dart';
import 'package:eds_beta/core/styles.dart';
import 'package:eds_beta/features/main_layout/cart/view/address_selection_page.dart';
import 'package:eds_beta/models/app_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CartView extends ConsumerStatefulWidget {
  const CartView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartViewState();
}

class _CartViewState extends ConsumerState<CartView> {
  double _total = 0;
  bool _loading = false;
  List<CartItemModel> cartItems = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    refreshCartItems();
    // ref.watch(cartAPIProvider).addListener((state) async {
    //   setState(() {
    //     _loading = true;
    //   });
    //   cartItems = await ref.read(cartAPIProvider).getProductsInCart();
    //   setState(() {
    //     cartItems = cartItems;
    //     calculateCart(cartItems);
    //     _loading = false;
    //   });
    // });
  }

  void refreshCartItems() async {
    setState(() {
      _loading = true;
    });
    cartItems = await ref.read(cartAPIProvider).getProductsInCart();
    setState(() {
      cartItems = cartItems;
      calculateCart(cartItems);
      _loading = false;
    });
  }

  void calculateCart(List<CartItemModel> cartItems) {
    double total = 0;
    for (var element in cartItems) {
      total += element.quantity * double.parse(element.product.currentPrice);
      log("product: ${element.product.name} total: ${element.quantity * double.parse(element.product.currentPrice)}");
    }
    setState(() {
      _total = total;
      log("total: $_total");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CART",
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              fontFamily: GoogleFonts.unbounded().fontFamily),
        ),
      ),
      body: _loading
          ? const CircularLoaderPage(
              message: "Getting items in your cart...",
            )
          : cartItems.isEmpty
              ? Column(
                  children: [
                    Image.asset(ImagesUrl.emptyImage),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 40),
                      child: Center(
                          child: Text(
                        "No items in cart... Browse products to add items to cart",
                        style: AppStyles.sectionHeading.copyWith(fontSize: 28),
                      )),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            itemBuilder: (context, index) {
                              return CartItemCard(
                                cartItem: cartItems[index],
                                onUpdate: refreshCartItems,
                              );
                            },
                            itemCount: cartItems.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "$_total",
                                      style: TextStyle(
                                        fontFamily: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold)
                                            .fontFamily,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      "*Shipping charges will be calculated at checkout",
                                      style: TextStyle(
                                        fontFamily: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w300)
                                            .fontFamily,
                                        fontSize: 8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                child: PrimaryButton(
                                    text: "CHECKOUT",
                                    enable: true,
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AddressSelectionPage()));
                                    }),
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

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  dispose() {
    super.dispose();
  }
}
