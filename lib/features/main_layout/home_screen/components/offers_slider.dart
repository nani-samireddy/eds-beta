import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eds_beta/common/components/home_loading.dart';
import 'package:eds_beta/providers/database_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'offer_detailed_view.dart';

class OffersCarosel extends ConsumerStatefulWidget {
  const OffersCarosel({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OffersCaroselState();
}

class _OffersCaroselState extends ConsumerState<OffersCarosel> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(offersProvider).when(
          loading: () =>
              const RectangularSKLOader(height: 180, width: double.infinity),
          error: (error, stackTrace) {
            log(error.toString());
            return Text(error.toString());
          },
          data: (data) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: CarouselSlider(
                items: data!
                    .map(
                      (e) => GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  OfferDetailedView(offer: e)));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(e.image),
                        ),
                      ),
                    )
                    .toList(),
                options: CarouselOptions(
                  height: 180,
                  enlargeCenterPage: false,
                  viewportFraction: 1,
                  padEnds: true,
                  autoPlay: true,
                ),
              ),
            );
          },
        );
  }
}
