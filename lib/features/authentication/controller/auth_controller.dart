import 'dart:developer';

import 'package:eds_beta/api/authentication_api.dart';
import 'package:eds_beta/api/database_api.dart';
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
  return AuthController(authAPI: authAPI, databaseAPI: databaseAPI);
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final DatabaseAPI _databaseAPI;

  AuthController({required AuthAPI authAPI, required DatabaseAPI databaseAPI})
      : _authAPI = authAPI,
        _databaseAPI = databaseAPI,
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
    return await _authAPI.sigInWithOTP(smsCode: otp).then((value) {
      return value.fold((l) => false, (r) {
        _databaseAPI.getUserDataFromDB(uid: r.uid).then(
          (value) async {
            if (value == null) {
              log("Creating a new user");
              log("user that is being added is: $r");
              // Add user to database
              await _databaseAPI.addUserToDB(
                  user: UserModel(
                      cartItems: [],
                      uid: r.uid,
                      name: '',
                      email: '',
                      phone: r.phoneNumber ?? '',
                      wishListItems: []));
            }
          },
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Welcome ${r.displayName}')));
        return true;
      });
    }).catchError((error) {
      showSnackBar(
          context: context,
          content:
              "An error occurred: $error. Please try again later. 🥲 while signing in..");
      return false;
    });
  }

  Future<User?> currentUser() async {
    final res = await _authAPI.getCurrentUser();
    return res.fold((l) => null, (r) => r);
  }

  Future<void> signOut() async {
    await _authAPI.logout();
  }
}
