import 'package:eds_beta/api/authentication_api.dart';
import 'package:eds_beta/core/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  final authAPI = ref.watch(authAPIProvider);
  return AuthController(authAPI: authAPI);
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;

  AuthController({required AuthAPI authAPI})
      : _authAPI = authAPI,
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
      if (value is User) {
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
}
