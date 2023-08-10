import 'dart:developer';

import 'package:eds_beta/api/authentication_api.dart';
import 'package:eds_beta/api/database_api.dart';
import 'package:eds_beta/api/user_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_models.dart';
import '../providers/database_providers.dart';

final cartAPIProvider = Provider<CartAPI>((ref) {
  final userAPI = ref.watch(userAPIProvider);
  final databaseAPI = ref.watch(databaseAPIProvider);
  final authAPI = ref.watch(authAPIProvider);
  return CartAPI(userAPI: userAPI, databaseAPI: databaseAPI, authAPI: authAPI);
});

final cartItemsProvider = FutureProvider<List<CartItemModel>>((ref) async {
  final cartAPI = ref.watch(cartAPIProvider);
  return await cartAPI.getCartItems();
});

abstract class ICartAPI {
  Future<List<CartItemModel>> getCartItems();
  Future<void> addCartItem({required CartItemModel cartItem});
  Future<void> removeCartItem({required CartItemModel cartItem});
  Future<void> clearCart();
  Future<bool> isItemInCart({required String productId});
  Future<void> getProductsInCart();
}

class CartAPI implements ICartAPI {
  final UserAPI _userAPI;
  final DatabaseAPI _databaseAPI;
  final AuthAPI _authAPI;
  List<CartItemModel> _noUserCartItems = [];
  CartAPI(
      {required UserAPI userAPI,
      required DatabaseAPI databaseAPI,
      required AuthAPI authAPI})
      : _userAPI = userAPI,
        _databaseAPI = databaseAPI,
        _authAPI = authAPI;

  @override
  Future<void> addCartItem({required CartItemModel cartItem}) async {
    try {
      _userAPI.currentUser().then((user) async {
        if (user == null) {
          _noUserCartItems.add(cartItem);
          return;
        }
        await _databaseAPI.addCartItem(user: user, cartItem: cartItem);
      });
    } catch (e) {
      log("Error in addCartItem: $e");
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      _noUserCartItems.clear();
    } catch (e) {
      log("Error in clearCart: $e");
    }
  }

  @override
  Future<void> removeCartItem({required CartItemModel cartItem}) async {
    try {
      await _userAPI.currentUser().then((user) async {
        if (user == null) {
          _noUserCartItems.remove(cartItem);
          return;
        }
        await _databaseAPI.removeCartItem(
            user: user, productId: cartItem.productId);
      });
    } catch (e) {
      log("Error in removeCartItem: $e");
    }
  }

  @override
  Future<List<CartItemModel>> getCartItems() async {
    List<CartItemModel> cartItems = [];
    try {
      final UserModel? user = await _userAPI.currentUser();
      if (user == null) {
        return _noUserCartItems;
      }
      if (user.cartItems.isEmpty) {
        return cartItems;
      }
      return user.cartItems;
    } catch (e) {
      log(" Error in getCartItems: $e");
      return cartItems;
    }
  }

  @override
  Future<bool> isItemInCart({required String productId}) async {
    try {
      return await getCartItems().then(
          (value) => value.any((element) => element.productId == productId));
    } catch (e) {
      log("Error in isItemInCart: $e");
      return false;
    }
  }

  @override
  Future<void> getProductsInCart() async {
    try {
      List<ProductModel> products =
          await _userAPI.currentUser().then((user) async {
        if (user != null) {
          return await _databaseAPI.getUserCartItems(user: user);
        } else {
          return await _databaseAPI.getProductsWithIds(
              ids: _noUserCartItems.map((e) => e.productId).toList());
        }
      });
    } catch (e) {
      log("Error in getProductsInCart: $e");
    }
  }
}
