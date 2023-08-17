import 'package:eds_beta/api/cart_api.dart';
import 'package:eds_beta/common/components/cart_item_card.dart';
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
  double _subtotal = 0;
  double _saved = 0;
  double _total = 0;
  @override
  void didChangeDependencies() {
    ref.watch(cartAPIProvider).addListener((state) {
      setState(() {
        cartItems = state;
      });
    });

    super.didChangeDependencies();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  // void calculateCart() {
  //   double subtotal = 0;
  //   double saved = 0;
  //   double total = 0;
  //   cartItems.forEach((element) {
  //     subtotal += element.quantity * element.product.price;
  //     saved += element.quantity * element.product.price;
  //     total += element.quantity * element.product.price;
  //   });
  //   setState(() {
  //     _subtotal = subtotal;
  //     _saved = saved;
  //     _total = total;
  //   });
  // }

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
          child: Column(
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
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.02),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Subtotal",
                            style: TextStyle(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        Text("Subtotal",
                            style: TextStyle(
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
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
