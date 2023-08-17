import 'package:eds_beta/api/wishlist_api.dart';
import 'package:eds_beta/common/common.dart';
import 'package:eds_beta/common/components/product_card.dart';
import 'package:eds_beta/models/app_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class WishlistView extends ConsumerStatefulWidget {
  const WishlistView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WishlistViewState();
}

class _WishlistViewState extends ConsumerState<WishlistView> {
  List<ProductModel> _wishlistItems = [];
  List<WishlistItemModel> _wishlistItemModels = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWishlistItems();
  }

  Future<void> fetchWishlistItems() async {
    setState(() {
      _isLoading = true;
    });
    final wishlistItems =
        await ref.read(wishlistAPIProvider.notifier).getProductsInWishlist();
    setState(() {
      _wishlistItems = wishlistItems;
      _isLoading = false;
    });
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
          "WISHLIST",
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              fontFamily: GoogleFonts.unbounded().fontFamily),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: _isLoading
            ? const CircularLoaderPage(
                message: "Loading your wishlist hold on a second 😁",
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${_wishlistItems.length} items",
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: GoogleFonts.dmSans().fontFamily,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14.0,
                            mainAxisSpacing: 14.0,
                            mainAxisExtent: 300),
                    itemBuilder: (context, index) {
                      return ProductCard(
                        product: _wishlistItems[index],
                      );
                    },
                    itemCount: _wishlistItems.length,
                  ),
                ],
              ),
      ),
    );
  }
}
