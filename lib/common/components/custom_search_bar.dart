import 'dart:developer';

import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SearchBar(
        onTap: () {
          log("Search");
        },
        leading: const Icon(Icons.search_rounded),
        hintText: "Search",
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
      ),
    );
  }
}
