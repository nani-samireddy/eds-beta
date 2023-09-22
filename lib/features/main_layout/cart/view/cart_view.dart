import 'package:eds_beta/api/cart_api.dart';
import 'package:eds_beta/common/components/cart_item_card.dart';
import 'package:eds_beta/constants/constans.dart';
import 'package:eds_beta/core/styles.dart';
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
  List<CartItemModel> cartItems = [];

  double _total = 0;
  bool _loading = false;
  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    getCartItems();
  }

  getCartItems() async {
    setState(() {
      _loading = true;

      final res = ref.watch(cartAPIProvider).cartItems;

      cartItems = res;
      calculateCart();
      _loading = false;
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void calculateCart() {
    double total = 0;
    for (var element in cartItems) {
      total += element.quantity * double.parse(element.product.currentPrice);
    }
    setState(() {
      _total = total;
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
        body: SingleChildScrollView(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
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
                            style:
                                AppStyles.sectionHeading.copyWith(fontSize: 28),
                          )),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        ListView.builder(
                          itemBuilder: (context, index) {
                            return CartItemCard(cartItem: cartItems[index]);
                          },
                          itemCount: cartItems.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.02),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total",
                                      style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                  Text("$_total",
                                      style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "(Shipping charges will be calculated at checkout)",
                                      style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.poppins().fontFamily,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w300)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
        ));
  }
}
