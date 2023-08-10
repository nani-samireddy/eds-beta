import 'package:eds_beta/api/authentication_api.dart';
import 'package:eds_beta/features/authentication/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Profile'),
          ElevatedButton(
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}