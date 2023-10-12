import 'dart:developer';
import 'package:eds_beta/api/database_api.dart';
import 'package:eds_beta/providers/database_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_models.dart';

final userAPIProvider = StateNotifierProvider<UserAPI, UserModel?>((ref) {
  final databaseAPI = ref.watch(databaseAPIProvider);
  return UserAPI(databaseAPI: databaseAPI);
});

abstract class IUserAPI {
  Future<void> setUserData({required String uid});
  Future<UserModel?> createUser({required User user});
  Future<List<CartItemModel>> getCartItems();
  Future<void> setUserFromFirebaseUser({required User user});
}

class UserAPI extends StateNotifier<UserModel?> implements IUserAPI {
  final DatabaseAPI _databaseAPI;

  final UserModel _noUser = UserModel(
      uid: "",
      email: "",
      name: "",
      cartItems: [],
      wishListItems: [],
      phone: '',
      addresses: []);

  UserAPI({
    required DatabaseAPI databaseAPI,
  })  : _databaseAPI = databaseAPI,
        super(null);

  UserModel? get user {
    return state;
  }

  @override
  Future<void> setUserData({required String uid}) async {
    try {
      final user = await _databaseAPI.getUserDataFromDB(uid: uid);
      state = user;
    } catch (e) {
      log("Error in while getting UserModel: $e");
    }
  }

  @override
  Future<UserModel?> createUser({required User? user}) async {
    if (user != null) {
      UserModel userModel = UserModel.fromFirebaseUser(user: user);
      await _databaseAPI.createUserDoc(userModel: userModel);
    }
    return null;
  }

  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      if (state == null) {
        return [];
      }
      return state!.cartItems;
    } catch (e) {
      log("Error in getCartItems: $e");
      return [];
    }
  }

  @override
  Future<void> setUserFromFirebaseUser({required User user}) async {
    try {
      final userModel = UserModel.fromFirebaseUser(user: user);
      state = userModel;
    } catch (e) {
      log("Error in setUserFromFirebaseUser: $e");
    }
  }

  Future<void> updateCartItems({required List<CartItemModel> cartItems}) async {
    try {
      if (state == null) {
        return;
      }
      state = state!.copyWith(cartItems: cartItems);
      await _databaseAPI.updateUserCartItems(
          user: state!, cartItems: state!.cartItems);
      log("Cart Items: ${state!.cartItems.length}");
    } catch (e) {
      log("Error in updateCartItems: $e");
    }
  }

  Future<void> updateWishListItems(
      {required List<WishlistItemModel> wishListItems}) async {
    try {
      if (state == null) {
        return;
      }
      state = state!.copyWith(wishListItems: wishListItems);
      await _databaseAPI.updateUserWishListItems(
          user: state!, wishlistItems: state!.wishListItems);
    } catch (e) {
      log("Error in updateWishListItems: $e");
    }
  }

  Future<void> addAddress({required AddressModel address}) async {
    try {
      if (state == null) {
        return;
      }
      state = state!.copyWith(
        addresses: [...state!.addresses, address],
      );
      await _databaseAPI.updateUserAddresses(
        uid: state!.uid,
        addresses: state!.addresses,
      );
    } catch (e) {
      log("Error in addAddress: $e");
    }
  }

  Future<void> updateAddress({required AddressModel address}) async {
    try {
      if (state == null) {
        return;
      }
      final addresses = state!.addresses;
      final index = addresses.indexWhere((element) => element == address);
      addresses[index] = address;
      state = state!.copyWith(addresses: addresses);
      await _databaseAPI.updateUserAddresses(
        uid: state!.uid,
        addresses: state!.addresses,
      );
    } catch (e) {
      log("Error in updateAddress: $e");
    }
  }

  Future<List<AddressModel>> getAddresses() async {
    try {
      if (state == null) {
        return [];
      }
      
      return state!.addresses;

    } catch (e) {
      log("Error in getAddresses: $e");
      return [];
    }
  }
}
