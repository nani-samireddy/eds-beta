import 'package:carousel_slider/carousel_slider.dart';
import 'package:eds_beta/theme/theme.dart';
import 'package:flutter/material.dart';

class ProductImagesSlider extends StatefulWidget {
  const ProductImagesSlider({super.key, required this.images});
  final List<String> images;

  @override
  State<ProductImagesSlider> createState() => _ProductImagesSliderState();
}

class _ProductImagesSliderState extends State<ProductImagesSlider> {
  int index = 0;
  CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CarouselSlider.builder(
          carouselController: carouselController,
          itemCount: widget.images.length,
          itemBuilder: (context, index, realIndex) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.network(
                  widget.images[index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              setState(() {
                this.index = index;
              });
            },
            height: 500,
            enlargeCenterPage: true,
            viewportFraction: .97,
            autoPlay: true,
            scrollDirection: Axis.horizontal,
            enlargeFactor: .3,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Pallete.backgroundColor,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < widget.images.length; i++)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      index = i;
                      carouselController.animateToPage(i,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      boxShadow: i == index
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(.1),
                                blurRadius: 30,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : null,
                      border: Border.all(
                        color: i == index
                            ? Pallete.whiteAccent
                            : Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    width: i == index ? 30 : 20,
                    height: i == index ? 30 : 20,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.images[i],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
            ],
          ),
        )
      ],
    );
  }
}
