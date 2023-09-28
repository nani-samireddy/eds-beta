import 'dart:developer';
import 'package:eds_beta/common/components/home_loading.dart';
import 'package:eds_beta/core/styles.dart';
import 'package:eds_beta/features/main_layout/search/results_page_view.dart';
import 'package:eds_beta/providers/database_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoriesListView extends ConsumerStatefulWidget {
  const CategoriesListView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategoriesListViewState();
}

class _CategoriesListViewState extends ConsumerState<CategoriesListView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Text("Categories", style: AppStyles.sectionHeading),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: ref.watch(categoriesProvider).when(
                data: (data) {
                  return data != null
                      ? data.map((e) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ResultsPageView(
                                        title: e.name,
                                        query: e.name,
                                      )));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.network(
                                      e.imageURL,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  e.name.replaceAll(' ', '\n'),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          );
                        }).toList()
                      : const [SizedBox.shrink()];
                },
                error: (error, stackTrace) {
                  log(error.toString());
                  return [Text(error.toString())];
                },
                loading: () {
                  return [
                    for (int i = 0; i < 5; i++)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: const CircularSKLoader(
                                height: 60,
                                width: 60,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const RectangularSKLOader(
                            height: 12,
                            width: 60,
                          )
                        ],
                      )
                  ];
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
