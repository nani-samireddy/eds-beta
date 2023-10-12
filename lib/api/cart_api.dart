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
  bool isItemInCart({required String productId, required SizeModel? size});
  void setProductsInCart();
  void setCartItems({required List<CartItemModel> cartItems});
  Future<void> changeQuantity({required CartItemModel cartItem});
  Future<void> addItemToCart({required CartItemDatabaseModel cartItem});
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
        super([]) {
    _userAPI.addListener((user) {
      state = user?.cartItems ?? [];
    });
  }

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
      log("Cart Items: ${state.length}");
      if (user == null) {
        return;
      }
      await _userAPI.updateCartItems(cartItems: state);
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
      await _userAPI.updateCartItems(cartItems: state);
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
      await _userAPI.updateCartItems(cartItems: state);
    } catch (e) {
      log("Error in removeCartItem: $e");
    }
  }

  @override
  bool isItemInCart({required String productId, required SizeModel? size}) {
    try {
      if (size != null) {
        return state.any((element) =>
            element.productId == productId && element.size == size);
      } else {
        return state.any((element) => element.productId == productId);
      }
    } catch (e) {
      log("Error in isItemInCart: $e");
      return false;
    }
  }

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

  @override
  Future<void> changeQuantity({required CartItemModel cartItem}) async {
    try {
      final user = _userAPI.user;
      final index = state.indexWhere((element) =>
          element.productId == cartItem.productId &&
          element.size == cartItem.size);
      if (index == -1) {
        return;
      }
      state[index] = cartItem;
      state = [...state];
      if (user == null) {
        return;
      }
      await _userAPI.updateCartItems(cartItems: state);
    } catch (e) {
      log("Error in changeQuantity: $e");
    }
  }

  @override
  Future<void> addItemToCart({required CartItemDatabaseModel cartItem}) {
    try {} catch (e) {
      log("Error in addItemToCart: $e");
    }
  }
}
