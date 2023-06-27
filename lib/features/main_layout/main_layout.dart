import 'package:eds_beta/features/main_layout/cart/view/cart_view.dart';
import 'package:eds_beta/features/main_layout/home_screen/home_view.dart';
import 'package:eds_beta/features/main_layout/liked/view/liked_view.dart';
import 'package:eds_beta/features/main_layout/profile/view/profile_view.dart';
import 'package:eds_beta/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainLayout extends ConsumerStatefulWidget {
  const MainLayout({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainLayoutState();
}

class _MainLayoutState extends ConsumerState<MainLayout> {
  String? uid;

  @override
  void initState() {
    super.initState();
  }

  final _views = [
    const HomeView(),
    const CartView(),
    const LikedView(),
    const ProfileView(),
    // this is a dummy widget to ignore the error RangeError (index): Invalid value: Not in inclusive range 0..2: 3
    const SizedBox.shrink()
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "ENDLESS",
          style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              fontFamily: GoogleFonts.unbounded().fontFamily),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 6),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search_rounded,
                size: 32,
                weight: 700,
                color: Pallete.black,
              ),
            ),
          ),
        ],
      ),
      body: _views[_selectedIndex],
      bottomNavigationBar: GNav(
          selectedIndex: _selectedIndex,
          onTabChange: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          backgroundColor: Pallete.black,
          color: Pallete.fadedIconColor,
          activeColor: Pallete.bottomNavActiveColor,
          gap: 10,
          padding: const EdgeInsets.all(28),
          iconSize: 24,
          textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: Pallete.bottomNavActiveColor),
          tabs: const [
            GButton(
              icon: Icons.explore_rounded,
              text: 'HOME',
            ),
            GButton(
              icon: Icons.local_mall_rounded,
              text: 'CART',
            ),
            GButton(
              icon: Icons.favorite_rounded,
              text: 'LIKED',
            ),
            GButton(
              icon: Icons.account_circle_rounded,
              text: 'PROFILE',
            ),
          ]),
    );
  }
}