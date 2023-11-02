import 'package:eds_beta/common/components/page_padding.dart';
import 'package:eds_beta/features/main_layout/cart/components/freshkart_categories_grid.dart';
import 'package:eds_beta/features/main_layout/cart/components/freshkart_offers_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FreshKartLayout extends ConsumerStatefulWidget {
  const FreshKartLayout({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FreshKartLayoutState();
}

class _FreshKartLayoutState extends ConsumerState<FreshKartLayout> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: PagePadding(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [FreshKartOffersCarosel(), FreshKartCategoriesGrid()],
        ),
      ),
    );
  }
}
