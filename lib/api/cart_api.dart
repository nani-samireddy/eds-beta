import 'dart:developer';

import 'package:eds_beta/api/authentication_api.dart';
import 'package:eds_beta/api/database_api.dart';
import 'package:eds_beta/api/user_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../models/app_models.dart';
import '../providers/database_providers.dart';

// final itemsInCartProvider = FutureProvider<List<CartItemModel>>((ref) async {
//   final cartAPI = ref.watch(cartAPIProvider);
//   final cartItems = await cartAPI.getProductsInCart();
//   return cartItems;
// });

final cartAPIProvider = Provider<CartAPI>((ref) {
  final userAPI = ref.watch(userAPIProvider.notifier);
  final databaseAPI = ref.watch(databaseAPIProvider);
  final authAPI = ref.watch(authAPIProvider);
  return CartAPI(userAPI: userAPI, databaseAPI: databaseAPI, authAPI: authAPI);
});

abstract class ICartAPI {
  Future<void> addCartItem({required CartItemDatabaseModel cartItem});
  Future<void> removeCartItem({required CartItemDatabaseModel cartItem});
  Future<void> clearCart();
  bool isItemInCart({required String productId, required SizeModel? size});
  void setProductsInCart();
  void setCartItems({required List<CartItemDatabaseModel> cartItems});
  Future<void> changeQuantity({required CartItemDatabaseModel cartItem});
  Future<List<CartItemModel>> getProductsInCart();
}

class CartAPI extends StateNotifier<List<CartItemDatabaseModel>>
    implements ICartAPI {
  bool _isUpdated = true;
  final UserAPI _userAPI;
  final DatabaseAPI _databaseAPI;
  List<CartItemModel> cartItemsWithProductModel = [];
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

  List<CartItemDatabaseModel> get cartItems => state;

  @override
  void setCartItems({required List<CartItemDatabaseModel> cartItems}) {
    state = cartItems;
    _isUpdated = true;
  }

  @override
  Future<void> addCartItem({required CartItemDatabaseModel cartItem}) async {
    try {
      final user = _userAPI.user;
      state = [...state, cartItem];
      log("Cart Items: ${state.length}");
      _isUpdated = true;
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
      _isUpdated = true;
      if (user == null) {
        return;
      }
      await _userAPI.updateCartItems(cartItems: state);
    } catch (e) {
      log("Error in clearCart: $e");
    }
  }

  @override
  Future<void> removeCartItem({required CartItemDatabaseModel cartItem}) async {
    log("removeCartItem: ${cartItem.productId}");
    try {
      final user = _userAPI.user;
      final remainingItems = state
          .where((element) =>
              element.productId != cartItem.productId ||
              element.size != cartItem.size)
          .toList();
      state = [...remainingItems];
      log("$state  after removing");
      _isUpdated = true;
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
            element.productId == productId && element.size == size.size);
      } else {
        return state.any((element) => element.productId == productId);
      }
    } catch (e) {
      log("Error in isItemInCart: $e");
      return false;
    }
  }

  @override
  Future<List<CartItemModel>> getProductsInCart() async {
    try {
      if (_isUpdated) {
        final products = await _databaseAPI.getProductsWithIds(
            ids: state.map((e) => e.productId).toList());

        final cartItems = state.map((e) {
          final product = products
              .firstWhere((element) => element.productId == e.productId);
          return CartItemModel(
            productId: e.productId,
            product: product,
            quantity: e.quantity,
            size:
                product.sizes?.firstWhere((element) => element.size == e.size),
          );
        }).toList();
        cartItemsWithProductModel = cartItems;
        _isUpdated = false;
      }
      return cartItemsWithProductModel;
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
      _isUpdated = true;
    } catch (e) {
      log("Error in setProductsInCart: $e");
    }
  }

  @override
  Future<void> changeQuantity({required CartItemDatabaseModel cartItem}) async {
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
      _isUpdated = true;
      if (user == null) {
        return;
      }
      await _userAPI.updateCartItems(cartItems: state);
    } catch (e) {
      log("Error in changeQuantity: $e");
    }
  }
}
