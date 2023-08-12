import 'dart:developer';
import 'package:eds_beta/models/app_models.dart';
import 'package:eds_beta/providers/database_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_api.dart';
import 'user_api.dart';

final wishlistAPIProvider =
    StateNotifierProvider<WishlistAPI, List<WishlistItemModel>>((ref) {
  final databaseAPI = ref.watch(databaseAPIProvider);
  final userAPI = ref.watch(userAPIProvider.notifier);
  return WishlistAPI(databaseAPI: databaseAPI, userAPI: userAPI);
});

abstract class IWishlistAPI {
  Future<void> addWishlistItem({required WishlistItemModel wishlistItem});
  Future<void> removeWishlistItem({required WishlistItemModel wishlistItem});
  Future<void> clearWishlist();
  bool isItemInWishlist({required String productId});
  Future<void> getProductsInWishlist();
  void setProductsInWishlist();
  void setWishlistItems({required List<WishlistItemModel> wishlistItems});
}

class WishlistAPI extends StateNotifier<List<WishlistItemModel>>
    implements IWishlistAPI {
  final UserAPI _userAPI;
  final DatabaseAPI _databaseAPI;

  WishlistAPI({required DatabaseAPI databaseAPI, required UserAPI userAPI})
      : _userAPI = userAPI,
        _databaseAPI = databaseAPI,
        super([]) {
    _userAPI.addListener((user) {
      if (user == null) {
        state = state.isEmpty ? [] : state;
        return;
      }
      state = user.wishListItems;
    });
  }

  @override
  Future<void> addWishlistItem(
      {required WishlistItemModel wishlistItem}) async {
    try {
      final user = _userAPI.user;
      state = [...state, wishlistItem];
      if (user == null) {
        return;
      }
      return await _userAPI.updateWishListItems(wishListItems: state);
    } catch (e) {
      log("Error in addWishlistItem: $e");
    }
  }

  @override
  Future<void> clearWishlist() async {
    try {
      state = [];
      final user = _userAPI.user;
      if (user == null) {
        return;
      }
      return await _userAPI.updateWishListItems(wishListItems: state);
    } catch (e) {
      log("Error in clearWishlist: $e");
    }
  }

  @override
  Future<List<ProductModel>> getProductsInWishlist() async {
    try {
      if (state.isEmpty) {
        return [];
      }
      return await _databaseAPI.getProductsWithIds(
          ids: state.map((e) => e.productId).toList());
    } catch (e) {
      log("Error in getProductsInWishlist: $e");
      return [];
    }
  }

  @override
  bool isItemInWishlist({required String productId}) {
    return state.any((element) => element.productId == productId);
  }

  @override
  Future<void> removeWishlistItem({required WishlistItemModel wishlistItem}) {
    try {
      state = state
          .where((element) => element.productId != wishlistItem.productId)
          .toList();
      final user = _userAPI.user;
      if (user == null) {
        return Future.value();
      }
      return _userAPI.updateWishListItems(wishListItems: state);
    } catch (e) {
      log("Error in removeWishlistItem: $e");
      return Future.value();
    }
  }

  @override
  void setProductsInWishlist() {
    try {
      final user = _userAPI.user;
      if (user == null) {
        return;
      }
      state = user.wishListItems;
    } catch (e) {
      log("Error in setProductsInWishlist: $e");
    }
  }

  @override
  void setWishlistItems({required List<WishlistItemModel> wishlistItems}) {
    // TODO: implement setWishlistItems
  }
}
