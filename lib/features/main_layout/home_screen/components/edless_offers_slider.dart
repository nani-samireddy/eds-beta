import 'dart:developer';
import 'package:eds_beta/common/carousel_slider.dart';
import 'package:eds_beta/common/components/home_loading.dart';
import 'package:eds_beta/providers/database_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'offer_detailed_view.dart';

class EndlessOffersCarosel extends ConsumerStatefulWidget {
  const EndlessOffersCarosel({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EndlessOffersCaroselState();
}

class _EndlessOffersCaroselState extends ConsumerState<EndlessOffersCarosel> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(endlessOffersSlidesDataProvider).when(
          loading: () =>
              const RectangularSKLOader(height: 180, width: double.infinity),
          error: (error, stackTrace) {
            log(error.toString());
            return Text(error.toString());
          },
          data: (data) {
            return OffersCarouselSlider(
              imageURLs: data!.map((e) => e.image).toList(),
              onTap: (index) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        OfferDetailedView(offer: data[index])));
              },
            );
          },
        );
  }
}
