import 'package:eds_beta/features/main_layout/cart/view/cart_view.dart';
import 'package:eds_beta/features/main_layout/home_screen/view/home_view.dart';
import 'package:eds_beta/features/main_layout/profile/view/profile_view.dart';
import 'package:eds_beta/features/main_layout/services/services_view.dart';
import 'package:eds_beta/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:heroicons/heroicons.dart';

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
    const ServicesView(),
    const CartView(),
    const ProfileView(),
    // this is a dummy widget to ignore the error RangeError (index): Invalid value: Not in inclusive range 0..2: 3
    const SizedBox.shrink()
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
          icon: const Icon(
            Icons.menu,
            size: 32,
            weight: 700,
            color: Colors.black,
          ),
        ),
            
        centerTitle: true,
        title: Text(
          "ENDLESS",
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
                )
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
          backgroundColor: Pallete.backgroundColor,
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
              icon: Icons.explore_outlined,
              text: 'EXPLORE',
            ),
            GButton(
              icon: Icons.grid_view_outlined,
              text: 'Services',
            ),
            GButton(
              icon: Icons.local_mall_outlined,
              text: 'CART',
            ),
           
            GButton(
              icon: Icons.account_circle_outlined,
              text: 'PROFILE',
            ),
          ]),
    );
  }
}
