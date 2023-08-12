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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "CART",
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                fontFamily: GoogleFonts.unbounded().fontFamily),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 6),
              child: IconButton(
                  onPressed: () {
                    //TODO: ADD NOTIFICATION PAGE NAVIGATION
                  },
                  icon: const Icon(
                    Icons.notifications_outlined,
                    size: 28,
                    weight: 300,
                    color: Colors.black,
                  )),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: CartItemCard(cartItem: cartItems[index]),
                  );
                },
                itemCount: cartItems.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
            ],
          ),
        )
    );
  }
}
