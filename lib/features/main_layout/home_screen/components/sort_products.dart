import 'package:eds_beta/common/common.dart';
import 'package:eds_beta/controllers/products_controller.dart';
import 'package:eds_beta/core/enums.dart';
import 'package:eds_beta/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SortProductsMenu extends StatefulWidget {
  const SortProductsMenu({super.key, required this.controller});
  final ProductsController controller;

  @override
  State<SortProductsMenu> createState() => _SortProductsMenuState();
}

class _SortProductsMenuState extends State<SortProductsMenu> {
  productSortRadioTypes? _sortType = productSortRadioTypes.newestFirst;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Sort by:",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.dmSans().fontFamily),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close)),
                ],
              ),
            ),
            ListTile(
              title: Text(
                'Newest First',
                style: TextStyle(
                    fontWeight: _sortType == productSortRadioTypes.newestFirst
                        ? FontWeight.bold
                        : FontWeight.w200,
                    fontSize: 16,
                    fontFamily: GoogleFonts.poppins().fontFamily),
              ),
              onTap: () {
                setState(() {
                  _sortType = productSortRadioTypes.newestFirst;
                });
              },
              leading: Radio<productSortRadioTypes>(
                activeColor: Pallete.black,
                value: productSortRadioTypes.newestFirst,
                groupValue: _sortType,
                onChanged: (productSortRadioTypes? value) {
                  setState(() {
                    _sortType = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text(
                'Price: Low to High',
                style: TextStyle(
                    fontWeight:
                        _sortType == productSortRadioTypes.priceLowToHigh
                            ? FontWeight.bold
                            : FontWeight.w200,
                    fontSize: 16,
                    fontFamily: GoogleFonts.poppins().fontFamily),
              ),
              onTap: () {
                setState(() {
                  _sortType = productSortRadioTypes.priceLowToHigh;
                });
              },
              leading: Radio<productSortRadioTypes>(
                activeColor: Pallete.black,
                value: productSortRadioTypes.priceLowToHigh,
                groupValue: _sortType,
                onChanged: (productSortRadioTypes? value) {
                  setState(() {
                    _sortType = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text(
                'Price: High to Low',
                style: TextStyle(
                    fontWeight:
                        _sortType == productSortRadioTypes.priceHighToLow
                            ? FontWeight.bold
                            : FontWeight.w200,
                    fontSize: 16,
                    fontFamily: GoogleFonts.poppins().fontFamily),
              ),
              onTap: () {
                setState(() {
                  _sortType = productSortRadioTypes.priceHighToLow;
                });
              },
              leading: Radio<productSortRadioTypes>(
                activeColor: Pallete.black,
                value: productSortRadioTypes.priceHighToLow,
                groupValue: _sortType,
                onChanged: (productSortRadioTypes? value) {
                  setState(() {
                    _sortType = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text(
                'Highest Discount',
                style: TextStyle(
                    fontWeight:
                        _sortType == productSortRadioTypes.highestDiscount
                            ? FontWeight.bold
                            : FontWeight.w200,
                    fontSize: 16,
                    fontFamily: GoogleFonts.poppins().fontFamily),
              ),
              onTap: () {
                setState(() {
                  _sortType = productSortRadioTypes.highestDiscount;
                });
              },
              leading: Radio<productSortRadioTypes>(
                activeColor: Pallete.black,
                value: productSortRadioTypes.highestDiscount,
                groupValue: _sortType,
                onChanged: (productSortRadioTypes? value) {
                  setState(() {
                    _sortType = value;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            PrimaryButton(text: "APPLY", onPressed: () {
              widget.controller.sortProducts(_sortType!);
              Navigator.of(context).pop();
            })
          ],
        ),
      ),
    );
  }
}
