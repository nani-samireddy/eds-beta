import 'package:eds_beta/features/main_layout/cart/view/cart_view.dart';
import 'package:eds_beta/features/main_layout/home_screen/view/home_view.dart';
import 'package:eds_beta/features/main_layout/profile/view/profile_view.dart';
import 'package:eds_beta/features/main_layout/services/services_view.dart';
import 'package:eds_beta/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        body: _views[_selectedIndex],
        bottomNavigationBar: NavigationBar(
          indicatorColor: Pallete.bottomNavActiveColor,
          destinations: const [
            NavigationDestination(
              icon: Icon(
                Icons.explore_outlined,
                color: Pallete.black,
              ),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.grid_view_outlined,
                color: Pallete.black,
              ),
              label: 'Services',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.local_mall_outlined,
                color: Pallete.black,
              ),
              label: 'Cart',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.account_circle_outlined,
                color: Pallete.black,
              ),
              label: 'Profile',
            ),
          ],
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ));
  }
}
