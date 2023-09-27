import 'package:eds_beta/common/common.dart';
import 'package:eds_beta/core/styles.dart';
import 'package:eds_beta/features/authentication/controller/auth_controller.dart';
import 'package:eds_beta/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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
        ListTile(
          title: Text("Edit Profile", style: AppStyles.sectionHeading),
          subtitle: Text(
            "Name, E-mail, DOB, Phone",
            style: TextStyle(
                fontSize: 14,
                fontFamily: GoogleFonts.dmSans().fontFamily,
                fontWeight: FontWeight.w400),
          ),
          trailing: const Icon(Icons.border_color_outlined),
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: const CustomDivider()),
        ListTile(
          title: Text(
            "Address Book",
            style: AppStyles.sectionHeading,
          ),
          subtitle: const Text("Manage your delivery addresses"),
          trailing: const Icon(Icons.border_color_outlined),
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: const CustomDivider()),
        ListTile(
          title: Text(
            "Logout",
            style: AppStyles.sectionHeading,
          ),
          subtitle: const Text("Logout from your account"),
          trailing: const Icon(Icons.logout_outlined),
          onTap: () {
            ref.read(authControllerProvider.notifier).signOut();
          },
        )
      ],
    );
  }
}
