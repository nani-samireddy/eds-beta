import 'package:eds_beta/common/common.dart';
import 'package:eds_beta/core/styles.dart';
import 'package:eds_beta/features/main_layout/profile/components/help_options.dart';
import 'package:eds_beta/features/main_layout/profile/components/orders_options.dart';
import 'package:eds_beta/features/main_layout/profile/components/profile_options.dart';
import 'package:eds_beta/features/main_layout/profile/components/settings_options.dart';
import 'package:eds_beta/features/main_layout/wishlist/view/wishlist_view.dart';
import 'package:eds_beta/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  final tabs = ["PROFILE", "ORDERS", "SETTINGS", "HELP"];
  final Map<String, Widget> _tabs = {
    "PROFILE": const ProfileOptions(),
    "ORDERS": const OrdersOptions(),
    "SETTINGS": const SettingsOptions(),
    "HELP": const HelpOptions(),
  };
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tabs.keys.elementAt(currentIndex),
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              fontFamily: GoogleFonts.unbounded().fontFamily),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const WishlistView()));
                    },
                    child: Column(
                      children: [
                        const Icon(
                          Icons.favorite_outline_sharp,
                          size: 40,
                          color: Pallete.grey,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "WISHLIST",
                          style: AppStyles.sectionHeading.copyWith(
                            color: Pallete.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      //TODO:GOTO INBOX
                    },
                    child: Column(
                      children: [
                        const Icon(
                          Icons.mail_outline_outlined,
                          size: 40,
                          color: Pallete.grey,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "INBOX",
                          style: AppStyles.sectionHeading.copyWith(
                            color: Pallete.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Pallete.grey,
                    width: 2,
                  ),
                  bottom: BorderSide(
                    color: Pallete.grey,
                    width: 2,
                  ),
                ),
              ),
              height: 70,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        child: Text(_tabs.keys.elementAt(index),
                            style: AppStyles.sectionHeading.copyWith(
                              color: currentIndex == index
                                  ? Pallete.black
                                  : Pallete.grey,
                            ))),
                  );
                },
                itemCount: _tabs.length,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: _tabs.values.elementAt(currentIndex),
            ),
          ],
        ),
      ),
    );
  }
}
