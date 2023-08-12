import 'package:eds_beta/features/authentication/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              fontFamily: GoogleFonts.unbounded().fontFamily),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 6),
            child: IconButton(
                onPressed: () {
                  //TODO: ADD NOTIFICATION PAGE NAVIGATION
                },
                icon: const Icon(
                  Icons.notifications_outlined,
                  size: 28,
                  weight: 300,
                  color: Colors.black,
                )),
          ),
        ],
      ),
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