import 'dart:developer';

import 'package:eds_beta/api/authentication_api.dart';
import 'package:eds_beta/api/cart_api.dart';
import 'package:eds_beta/api/user_api.dart';
import 'package:eds_beta/features/authentication/view/phone_number_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main_layout/main_layout.dart';

class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  setUserData() async {
    final user = ref.watch(authChangesProvider).value;
    if (user != null) {
      ref.read(userAPIProvider.notifier).setUserData(uid: user.uid);
      ref.read(cartAPIProvider).setProductsInCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authChangesProvider).value;
    if (user == null) {
      return const PhoneNumberView();
    } else {
      setUserData();
      return const MainLayout();
    }
  }
}
