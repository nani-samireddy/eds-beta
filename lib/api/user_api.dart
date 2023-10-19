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
  Future<List<CartItemDatabaseModel>> getCartItems();
  Future<void> setUserFromFirebaseUser({required User user});
  Future<void> addAddress({required AddressModel address});
  Future<void> updateAddress({required List<AddressModel> addresses});
  Future<void> deleteAddress({required AddressModel address});
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
    // try {
    log("sertting up user data");
    await _databaseAPI.getUserDataFromDB(uid: uid).then((value) {
      if (value != null) {
        state = value;
      } else {
        state = _noUser;
      }
    });
    // } catch (e) {
    //   log("Error in while getting UserModel: $e");
    // }
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
  Future<List<CartItemDatabaseModel>> getCartItems() async {
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

  Future<void> updateCartItems(
      {required List<CartItemDatabaseModel> cartItems}) async {
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

  @override
  Future<void> updateAddress({required List<AddressModel> addresses}) async {
    try {
      if (state == null) {
        return;
      }

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

  @override
  Future<void> deleteAddress({required AddressModel address}) async {
    try {
      if (state == null) {
        return;
      }
      final addresses = state!.addresses;
      addresses.remove(address);
      state = state!.copyWith(addresses: addresses);
      await _databaseAPI.updateUserAddresses(
        uid: state!.uid,
        addresses: state!.addresses,
      );
    } catch (e) {
      log("Error in deleteAddress: $e");
    }
  }
}
