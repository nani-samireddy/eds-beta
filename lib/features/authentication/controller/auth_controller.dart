import 'dart:developer';
import 'package:eds_beta/api/authentication_api.dart';
import 'package:eds_beta/api/database_api.dart';
import 'package:eds_beta/api/user_api.dart';
import 'package:eds_beta/core/utils.dart';
import 'package:eds_beta/models/user_model.dart';
import 'package:eds_beta/providers/database_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  final authAPI = ref.watch(authAPIProvider);
  final databaseAPI = ref.watch(databaseAPIProvider);
  final userAPI = ref.watch(userAPIProvider.notifier);
  return AuthController(
      authAPI: authAPI, databaseAPI: databaseAPI, userAPI: userAPI);
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final DatabaseAPI _databaseAPI;
  final UserAPI _userAPI;

  AuthController(
      {required AuthAPI authAPI,
      required DatabaseAPI databaseAPI,
      required UserAPI userAPI})
      : _authAPI = authAPI,
        _databaseAPI = databaseAPI,
        _userAPI = userAPI,
        super(false);

  void signUp(
      {required String email,
      required String password,
      required String name,
      required BuildContext context}) async {
    state = true;
    final res = await _authAPI.register(email: email, password: password);
    res.fold((l) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.message)));
    }, (r) {
      _databaseAPI.getUserDataFromDB(uid: r.uid).then((value) {
        if (value == null) {
          _databaseAPI.addUserToDB(
              user: UserModel(
                  cartItems: [],
                  uid: r.uid,
                  name: name,
                  email: email,
                  phone: '',
                  wishListItems: []));
        }
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Welcome $name')));
    });
    state = false;
  }

  Future<bool> sendOTP(
      {required String phoneNumber, required BuildContext context}) async {
    return await _authAPI.sendOTP(phoneNumber: "+91$phoneNumber").then((value) {
      if (value) {
        return true;
      }
      showSnackBar(
          context: context,
          content: "Something went wrong. Please try again later. 🥲");
      return false;
    }).catchError((error) {
      showSnackBar(
          context: context,
          content: "An error occurred: $error. Please try again later. 🥲");
      return false;
    });
  }

  Future<bool> reSendOTP(
      {required String phoneNumber, required BuildContext context}) async {
    return await _authAPI
        .reSendOTP(phoneNumber: "+91$phoneNumber")
        .then((value) {
      if (value) {
        return true;
      }
      showSnackBar(
          context: context,
          content: "Something went wrong. Please try again later. 🥲");
      return false;
    }).catchError((error) {
      showSnackBar(
          context: context,
          content: "An error occurred: $error. Please try again later. 🥲");
      return false;
    });
  }

  Future<bool> verifyOTP(
      {required String otp, required BuildContext context}) async {
    final res = await _authAPI.sigInWithOTP(smsCode: otp);
    final user = res.fold((l) => null, (r) => r);
    if (user == null) {
      return false;
    } else {
      await _databaseAPI.getUserDataFromDB(uid: user.uid).then((value) async {
        final userModel = UserModel(
            cartItems: [],
            uid: user.uid,
            name: user.displayName ?? '',
            email: user.email ?? '',
            phone: user.phoneNumber ?? '',
            wishListItems: []);
        if (value == null) {
          log("Creating a new user");
          log("user that is being added is: $user");
          // Add user to database
          await _databaseAPI.addUserToDB(user: userModel);
        }

        // Set user data
        await _userAPI.setUserData(uid: user.uid);
      });
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Welcome ${user.displayName}')));
      return true;
    }

  }

  Future<User?> currentUser() async {
    final res = await _authAPI.getCurrentUser();
    return res.fold((l) => null, (r) => r);
  }

  Future<void> signOut() async {
    await _authAPI.logout();
  }
}
