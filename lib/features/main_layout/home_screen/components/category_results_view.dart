import 'dart:developer';

import 'package:eds_beta/common/components/product_card.dart';
import 'package:eds_beta/common/components/products_not_found.dart';
import 'package:eds_beta/common/components/search/sort_and_filter.dart';
import 'package:eds_beta/features/main_layout/cart/view/cart_view.dart';
import 'package:eds_beta/features/main_layout/wishlist/view/wishlist_view.dart';
import 'package:eds_beta/models/app_models.dart';
import 'package:eds_beta/models/search_result_model.dart';
import 'package:eds_beta/providers/database_providers.dart';
import 'package:eds_beta/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryResultsView extends ConsumerStatefulWidget {
  const CategoryResultsView({super.key, required this.category});
  final CategoryModel category;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategoryResultsViewState();
}

class _CategoryResultsViewState extends ConsumerState<CategoryResultsView> {
  List<ProductModel> _products = [];
  bool _isLoading = true;
  late SearchResultModel _searchResult;

  @override
  void initState() {
    super.initState();
    getCategoryResults();
    _searchResult = SearchResultModel(
        title: widget.category.name,
        productCount: 0,
        query: widget.category.name);
  }

  getCategoryResults() async {
    _products = await ref
        .read(databaseAPIProvider)
        .getProductsByCategory(category: widget.category.name);
    setState(() {
      _products = _products;
      _isLoading = false;
      _searchResult.productCount = _products.length;
    });
  }

  void handleFilter() {}
  void handleSort() {}
  Future<void> handleLoadMore() async {
    log("load more");
    if (_searchResult.hasMore) {
      setState(() {
        _isLoading = true;
      });
      final resMore = await ref.read(databaseAPIProvider).loadMore(
            searchQuery: _searchResult,
            startAfter: _products.last.productId,
          );
      setState(() {
        _isLoading = false;
        _products += resMore;
        _searchResult.hasMore = resMore.isNotEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const WishlistView()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.local_mall_outlined),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (contect) => const CartView()));
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _products.isEmpty
              ? const ProductsNotFound()
              : Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
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
                                product: _products[index],
                              );
                            },
                            itemCount: _products.length,
                          ),
                          _searchResult.hasMore
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 30.0),
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 10),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          side: const BorderSide(
                                              color: Pallete.black,
                                              width: 1.0)),
                                    ),
                                    onPressed: handleLoadMore,
                                    child: const Text(
                                      'Load More',
                                      style: TextStyle(color: Pallete.black),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SortAndFilterProducts(
                            handleFilter: handleFilter,
                            handleSort: handleSort,
                          )),
                    ),
                  ],
                ),
    );
  }
}
