import 'package:eds_beta/features/main_layout/freshkart/view/freshkart_layout.dart';
import 'package:eds_beta/features/main_layout/home_screen/view/home_layout.dart';
import 'package:eds_beta/features/main_layout/search/search_page.dart';
import 'package:eds_beta/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eds_beta/models/app_models.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  late List<Offer> offers;
  final tabs = const [HomeLayout(), FreshKartLayout()];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = 0;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedIndex == 0
                    ? Pallete.primaryButtonBackgroundColor
                    : Colors.white,
                foregroundColor:
                    _selectedIndex == 0 ? Colors.white : Colors.black,
                elevation: _selectedIndex == 0 ? 1 : 0,
              ),
              child: Text(
                "ENDLESS",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    fontFamily: GoogleFonts.unbounded().fontFamily),
              ),
            ),
            const SizedBox(
              width: 6,
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedIndex == 1
                      ? Pallete.primaryButtonBackgroundColor
                      : Colors.white,
                  foregroundColor:
                      _selectedIndex == 1 ? Colors.white : Colors.black,
                  elevation: _selectedIndex == 1 ? 1 : 0,
                ),
                child: Text(
                  "FRESHKART",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      fontFamily: GoogleFonts.unbounded().fontFamily),
                )),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 6),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SearchPage(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.search_sharp,
                  size: 28,
                  weight: 300,
                  color: Colors.black,
                )),
          ),
        ],
      ),
      body: tabs[_selectedIndex],
    );
  }
}
