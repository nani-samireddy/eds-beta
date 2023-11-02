import 'dart:developer';

import 'package:eds_beta/common/common.dart';
import 'package:eds_beta/common/components/expandable_staggered_grid_view.dart';
import 'package:eds_beta/providers/database_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class FreshKartCategoriesGrid extends ConsumerStatefulWidget {
  const FreshKartCategoriesGrid({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FreshKartCategoriesGridState();
}

class _FreshKartCategoriesGridState
    extends ConsumerState<FreshKartCategoriesGrid> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(freshKartCategoriesProvider).when(
        data: (data) {
          return ExpandableStaggeredGridView(
            title: "Categories",
            items: data!,
            builder: (index) {
              return Material(
                borderRadius: BorderRadius.circular(12),
                elevation: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      height: 110,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        child: Image.network(
                          data[index].imageURL,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        data[index].name,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        error: (er, st) {
          log("Error: $er");
          return const CircularLoader();
        },
        loading: () => const CircularLoader());
  }
}
