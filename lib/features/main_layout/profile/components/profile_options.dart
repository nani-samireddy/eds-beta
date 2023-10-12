import 'package:eds_beta/common/common.dart';
import 'package:eds_beta/features/authentication/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileOptions extends ConsumerStatefulWidget {
  const ProfileOptions({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileOptionsState();
}

class _ProfileOptionsState extends ConsumerState<ProfileOptions> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const OptionListTile(
          title: "Edit Profile",
          icon: Icons.border_color_outlined,
          subtitle: "Name, E-mail, DOB, Phone",
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: const CustomDivider()),
        const OptionListTile(
          title: "Address Book",
          icon: Icons.border_color_outlined,
          subtitle: "Manage your delivery addresses",
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: const CustomDivider()),
        OptionListTile(
          title: "Logout",
          icon: Icons.logout_outlined,
          subtitle: "Logout from your account",
          onTap: () {
            ref.read(authControllerProvider.notifier).signOut();
          },
        ),
      ],
    );
  }
}
