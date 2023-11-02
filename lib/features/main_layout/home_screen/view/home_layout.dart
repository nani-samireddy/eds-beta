import 'package:eds_beta/common/components/page_padding.dart';
import 'package:eds_beta/features/main_layout/home_screen/components/categories_view.dart';
import 'package:eds_beta/features/main_layout/home_screen/components/new_products_section.dart';
import 'package:eds_beta/features/main_layout/home_screen/components/edless_offers_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeLayout extends ConsumerStatefulWidget {
  const HomeLayout({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends ConsumerState<HomeLayout> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: PagePadding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //CustomSearchBar(),
            EndlessOffersCarosel(),

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
              height: 100,
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
