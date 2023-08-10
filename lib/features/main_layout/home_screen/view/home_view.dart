import 'dart:developer';

import 'package:eds_beta/api/user_api.dart';
import 'package:eds_beta/common/components/common_components.dart';
import 'package:eds_beta/common/components/page_padding.dart';
import 'package:eds_beta/features/main_layout/home_screen/components/categories_view.dart';
import 'package:eds_beta/features/main_layout/home_screen/components/new_products_section.dart';
import 'package:eds_beta/features/main_layout/home_screen/components/offers_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eds_beta/models/app_models.dart';

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
    return SingleChildScrollView(
      child: PagePadding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomSearchBar(),
            const OffersCarosel(),
            ElevatedButton(
              onPressed: () async {
                final user = ref.watch(userAPIProvider.notifier).user;
                log("User: $user");
              },
              child: const Text("Add datat to database"),
            ),
            const CategoriesListView(),
            const NewProducts(),
            const SizedBox(
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
