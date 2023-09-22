import 'package:eds_beta/features/main_layout/search/search_page.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
        // child: SearchBar(
        //   onTap: () {
        //     Navigator.of(context).push(
        //         MaterialPageRoute(builder: (context) => const SearchPage()));
        //   },
        //   leading: const Icon(Icons.search_rounded),
        //   hintText: "Search",
        //   elevation: MaterialStateProperty.all(0),
        //   backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
        // ),
        child: GestureDetector(
        onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SearchPage()));
        },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20)),
            child: const Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.search_rounded),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Search",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                )
              ],
            ),
          ),
        )
    );
  }
}
