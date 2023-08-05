import 'dart:developer';

import 'package:eds_beta/api/database_api.dart';
import 'package:eds_beta/common/components/common_components.dart';
import 'package:eds_beta/common/components/page_padding.dart';
import 'package:eds_beta/features/main_layout/home_screen/components/categories_view.dart';
import 'package:eds_beta/features/main_layout/home_screen/components/new_products_section.dart';
import 'package:eds_beta/features/main_layout/home_screen/components/offers_slider.dart';
import 'package:eds_beta/models/offer_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    var data = ref.watch(homeScreenDataProvider);
    return const SingleChildScrollView(
      child: PagePadding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomSearchBar(),
            OffersCarosel(),
            // ElevatedButton(
            //   onPressed: () {
            //     log(":hii");
            //     ref.read(databaseAPIProvider).addProduct();
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
    );
  }
}
