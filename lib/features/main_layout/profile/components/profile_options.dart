import 'package:eds_beta/common/common.dart';
import 'package:eds_beta/features/authentication/controller/auth_controller.dart';
import 'package:eds_beta/features/main_layout/profile/view/address_book_view.dart';
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
        OptionListTile(
          title: "Address Book",
          icon: Icons.border_color_outlined,
          subtitle: "Manage your delivery addresses",
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddressBookView()));
          },
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
