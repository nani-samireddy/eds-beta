import 'package:carousel_slider/carousel_slider.dart';
import 'package:eds_beta/common/components/rounded_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eds_beta/models/app_models.dart';


class SectionCarouselSlider extends ConsumerStatefulWidget {
  const SectionCarouselSlider({super.key, required this.items});
  final List<SectionItemModel> items;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SectionCarouselSliderState();
}

class _SectionCarouselSliderState extends ConsumerState<SectionCarouselSlider> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        items: widget.items
            .map((e) => GestureDetector(
                onTap: () {
                  //TODO: add navigation to product search page
                },
                child: RoundedContainer(
                    child: Image.network(e.imageURL, fit: BoxFit.cover))))
            .toList(),
        options: CarouselOptions(
          enlargeCenterPage: true,
          viewportFraction: 1,
          padEnds: true,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
        ));
  }
}
