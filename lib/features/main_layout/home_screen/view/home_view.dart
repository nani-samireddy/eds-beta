import 'dart:developer';

import 'package:eds_beta/api/user_api.dart';
import 'package:eds_beta/common/components/page_padding.dart';
import 'package:eds_beta/features/main_layout/home_screen/components/categories_view.dart';
import 'package:eds_beta/features/main_layout/home_screen/components/new_products_section.dart';
import 'package:eds_beta/features/main_layout/home_screen/components/offers_slider.dart';
import 'package:eds_beta/features/main_layout/search/search_page.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userAPIProvider);
    log("User: $user");
    return Scaffold(
      appBar: AppBar(
        // leading: Builder(builder: (context) {
        //   return IconButton(
        //     onPressed: () {
        //       Scaffold.of(context).openDrawer();
        //     },
        //     icon: const Icon(
        //       Icons.menu,
        //       size: 32,
        //       weight: 700,
        //       color: Colors.black,
        //     ),
        //   );
        // }),
        centerTitle: false,
        title: Text(
          "Endless",
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
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SearchPage()));
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
      body: const SingleChildScrollView(
        child: PagePadding(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //CustomSearchBar(),
              OffersCarosel(),
              // ElevatedButton(
              //   onPressed: () async {
              //     await ref.read(databaseAPIProvider).addProduct();
              //     log("jii");
              //   },
              //   child: const Text("Add datat to database"),
              // ),
              CategoriesListView(),
              NewProducts(),
              SizedBox(
                height: 200,
              ),
              // Wrap(
              //   children: data
              //       .map((e) => DisplaySection(sectionItemsListModel: e))
              //       .toList(),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
