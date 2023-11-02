import 'dart:developer';

import 'package:eds_beta/api/authentication_api.dart';
import 'package:eds_beta/api/user_api.dart';
import 'package:eds_beta/common/circular_loading_page.dart';
import 'package:eds_beta/features/authentication/view/basic_details.dart';
import 'package:eds_beta/features/authentication/view/phone_number_view.dart';
import 'package:eds_beta/providers/database_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main_layout/main_layout.dart';

class AuthWrapper extends ConsumerStatefulWidget {
  const AuthWrapper({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends ConsumerState<AuthWrapper> {
  bool isUserNew = false;
  bool loading = false;

  checkUser({required String uid}) async {
    setState(() {
      loading = true;
    });
    await ref.read(databaseAPIProvider).isNewUser(uid: uid).then((value) {
      setState(() {
        isUserNew = value ?? false;
        loading = false;
      });
    });
  }

  setUserData() async {
    final user = ref.watch(authChangesProvider).value;
    if (user != null) {
      log("Setting user data");
      ref.read(userAPIProvider.notifier).setUserData(uid: user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authChangesProvider).value;
    if (user == null) {
      return const PhoneNumberView();
    } else {
      // checkUser(uid: user.uid);

      // setUserData();
      // return ref.read(userAPIProvider.notifier).doesBasicDetailsExist
      //     ? const MainLayout()
      //     : const BasicDetailsView();
      return ref
          .watch(setUserDetailsAndReturnDoesHaveBasicDetailsProvider)
          .when(data: (value) {
        return value ? const MainLayout() : const BasicDetailsView();
      }, error: (er, st) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Something went wrong")));
        return const MainLayout();
      }, loading: () {
        log("loading");
        return const CircularLoaderPage();
      });
    }
  }
}
