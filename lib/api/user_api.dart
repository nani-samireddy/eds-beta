import 'dart:developer';
import 'package:eds_beta/api/database_api.dart';
import 'package:eds_beta/features/authentication/controller/auth_controller.dart';

import 'package:eds_beta/providers/database_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_models.dart';

final userAPIProvider = Provider<UserAPI>((ref) {
  final databaseAPI = ref.watch(databaseAPIProvider);
  final authController = ref.watch(authControllerProvider.notifier);
  return UserAPI(databaseAPI: databaseAPI, authController: authController);
});




abstract class IUserAPI {
  Future<UserModel?> getUserData({required String uid});
  Future<UserModel?> createUser({required User user});
  Future<UserModel?> currentUser();
  Future<List<CartItemModel>> getCartItems();
}

class UserAPI implements IUserAPI {
  final DatabaseAPI _databaseAPI;

  final AuthController _authController;
  UserAPI(
      {required DatabaseAPI databaseAPI,
      required AuthController authController})
      : _databaseAPI = databaseAPI,
        _authController = authController;

  @override
  Future<UserModel?> getUserData({required String uid}) async {
    try {
      return await _databaseAPI.getUserDataFromDB(uid: uid);
    } catch (e) {
      log("Error in while getting UserModel: $e");
      return null;
    }
  }

  @override
  Future<UserModel?> createUser({required user}) async {
    final user = await _authController.currentUser();
    if (user != null) {
      UserModel userModel = UserModel.fromFirebaseUser(user: user);
      await _databaseAPI.createUserDoc(userModel: userModel);
    }
    return null;
  }

  @override
  Future<UserModel?> currentUser() async {
    try {
      final uid =
          await _authController.currentUser().then((value) => value!.uid);
      if (uid.isNotEmpty) {
        return await _databaseAPI.getUserDataFromDB(uid: uid);
      }
      return null;
    } catch (e) {
      log("Error in while getting currentUser UserModel: $e");
      return null;
    }
  }

  @override
  Future<List<CartItemModel>> getCartItems() async {
    try {
      final user = await _authController.currentUser();
      if (user == null) {
        return [];
      }
      return await currentUser().then((value) => value!.cartItems);
    } catch (e) {
      log("Error in getCartItems: $e");
      return [];
    }
  }
}
