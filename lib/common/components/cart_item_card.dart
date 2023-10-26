import 'dart:developer';

import 'package:eds_beta/api/cart_api.dart';
import 'package:eds_beta/models/cart_item_model.dart';
import 'package:eds_beta/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CartItemCard extends ConsumerStatefulWidget {
  const CartItemCard(
      {super.key, required this.cartItem, required this.onUpdate});
  final CartItemModel cartItem;
  final void Function() onUpdate;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartItemCardState();
}

class _CartItemCardState extends ConsumerState<CartItemCard> {
  late CartItemModel cartItem;

  @override
  void initState() {
    cartItem = widget.cartItem;
    super.initState();
  }

  handleQuantityChange({required int quantity}) {
    log("cart item count: $quantity");
    if (quantity == 0) {
      ref
          .read(cartAPIProvider)
          .removeCartItem(cartItem: widget.cartItem.toCartItemDatabaseModel());
    } else {
      CartItemModel cartItem = widget.cartItem;
      cartItem.quantity = quantity;
      ref
          .read(cartAPIProvider)
          .changeQuantity(cartItem: widget.cartItem.toCartItemDatabaseModel());
      setState(() {
        this.cartItem = cartItem;
      });
    }
    widget.onUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Pallete.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Pallete.blue.withOpacity(.09),
              offset: const Offset(0, 2),
              blurRadius: 10)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 110,
                    width: 110,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                widget.cartItem.product.images.first),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(18)),
                  ),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.cartItem.product.name,
                    style: TextStyle(
                        fontFamily: GoogleFonts.unbounded().fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    ' Price : ${widget.cartItem.size!.price.toString()}',
                    style: TextStyle(
                      color: Pallete.fadedIconColor,
                      fontFamily:
                          GoogleFonts.unbounded(fontWeight: FontWeight.w500)
                              .fontFamily,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    ' SIZE : ${widget.cartItem.size!.size.toString()}',
                    style: TextStyle(
                      color: Pallete.fadedIconColor,
                      fontFamily:
                          GoogleFonts.unbounded(fontWeight: FontWeight.w500)
                              .fontFamily,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                IconButton(
                    onPressed: () {
                      handleQuantityChange(
                          quantity: widget.cartItem.quantity + 1);
                    },
                    icon: const Icon(Icons.add)),
                Text(
                  widget.cartItem.quantity.toString(),
                  style: TextStyle(
                      fontFamily: GoogleFonts.unbounded().fontFamily,
                      fontWeight: FontWeight.w800),
                ),
                IconButton(
                    onPressed: () {
                      handleQuantityChange(
                          quantity: widget.cartItem.quantity - 1);
                    },
                    icon: const Icon(Icons.remove)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
