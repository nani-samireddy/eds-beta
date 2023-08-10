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
      log("user sds: $user");
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

  void updateCartItems({required List<CartItemModel> cartItems}) {
    try {
      if (state == null) {
        return;
      }
      state = state!.copyWith(cartItems: cartItems);
    } catch (e) {
      log("Error in updateCartItems: $e");
    }
  }
}
