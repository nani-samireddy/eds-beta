import 'dart:developer';

import 'package:eds_beta/api/authentication_api.dart';
import 'package:eds_beta/api/database_api.dart';
import 'package:eds_beta/api/user_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_models.dart';
import '../providers/database_providers.dart';

final cartAPIProvider = Provider<CartAPI>((ref) {
  final userAPI = ref.watch(userAPIProvider.notifier);
  final databaseAPI = ref.watch(databaseAPIProvider);
  final authAPI = ref.watch(authAPIProvider);
  return CartAPI(userAPI: userAPI, databaseAPI: databaseAPI, authAPI: authAPI);
});

abstract class ICartAPI {
  Future<void> addCartItem({required CartItemModel cartItem});
  Future<void> removeCartItem({required CartItemModel cartItem});
  Future<void> clearCart();
  bool isItemInCart({required String productId});
  Future<void> getProductsInCart();
  void setProductsInCart();
  void setCartItems({required List<CartItemModel> cartItems});
}

class CartAPI extends StateNotifier<List<CartItemModel>> implements ICartAPI {
  final UserAPI _userAPI;
  final DatabaseAPI _databaseAPI;
  CartAPI(
      {required UserAPI userAPI,
      required DatabaseAPI databaseAPI,
      required AuthAPI authAPI})
      : _userAPI = userAPI,
        _databaseAPI = databaseAPI,
        super([]);

  List<CartItemModel> get cartItems => state;

  @override
  void setCartItems({required List<CartItemModel> cartItems}) {
    state = cartItems;
  }

  @override
  Future<void> addCartItem({required CartItemModel cartItem}) async {
    try {
      final user = _userAPI.user;
      state = [...state, cartItem];
      if (user == null) {
        return;
      }
      _userAPI.updateCartItems(cartItems: state);
      await _databaseAPI.addCartItem(user: user, cartItem: cartItem);
    } catch (e) {
      log("Error in addCartItem: $e");
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      final user = _userAPI.user;
      state = [];
      if (user == null) {
        return;
      }
      _userAPI.updateCartItems(cartItems: state);
      await _databaseAPI.updateUserCartItems(user: user, cartItems: state);
    } catch (e) {
      log("Error in clearCart: $e");
    }
  }

  @override
  Future<void> removeCartItem({required CartItemModel cartItem}) async {
    try {
      final user = _userAPI.user;
      state = [...state]..remove(cartItem);
      if (user == null) {
        return;
      }
      _userAPI.updateCartItems(cartItems: state);
      await _databaseAPI.removeCartItem(
          user: user, productId: cartItem.productId);
    } catch (e) {
      log("Error in removeCartItem: $e");
    }
  }

  @override
  bool isItemInCart({required String productId}) {
    try {
      return state.any((element) => element.productId == productId);
    } catch (e) {
      log("Error in isItemInCart: $e");
      return false;
    }
  }

  @override
  Future<List<ProductModel>> getProductsInCart() async {
    try {
      return await _databaseAPI.getProductsWithIds(
          ids: state.map((e) => e.productId).toList());
    } catch (e) {
      log("Error in getProductsInCart: $e");
      return [];
    }
  }

  @override
  void setProductsInCart() {
    try {
      final user = _userAPI.user;
      if (user == null) {
        state = [];
        return;
      }
      state = [...user.cartItems];
    } catch (e) {
      log("Error in setProductsInCart: $e");
    }
  }
}
