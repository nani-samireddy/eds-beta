import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:eds_beta/api/database_api.dart';
import 'package:eds_beta/common/components/rounded_container.dart';
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
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) {
            log(error.toString());
            return Text(error.toString());
          },
          data: (data) {
            return CarouselSlider(
              items: data!
                  .map((e) => GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => OfferDetailedView(offer: e)));
                      },
                      child: RoundedContainer(child: Image.network(e.image))))
                  .toList(),
              options: CarouselOptions(
                height: 200,
                enlargeCenterPage: true,
                viewportFraction: 1,
                padEnds: false,
                autoPlay: true,
                enlargeFactor: 0.5,
              ),
            );
          },
        );
  }
}
