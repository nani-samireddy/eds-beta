import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OffersCarouselSlider extends ConsumerStatefulWidget {
  const OffersCarouselSlider(
      {super.key, required this.imageURLs, required this.onTap});
  final List<String>? imageURLs;
  final Function(int index) onTap;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OffersCarouselSliderState();
}

class _OffersCarouselSliderState extends ConsumerState<OffersCarouselSlider> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: CarouselSlider(
        items: widget.imageURLs!
            .map(
              (e) => GestureDetector(
                onTap: () => widget.onTap(widget.imageURLs!.indexOf(e)),
                child: Material(
                  elevation: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      e,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            )
            .toList(),
        options: CarouselOptions(
          height: 190,
          enlargeCenterPage: true,
          viewportFraction: 1,
          padEnds: true,
          autoPlay: true,
        ),
      ),
    );
  }
}
