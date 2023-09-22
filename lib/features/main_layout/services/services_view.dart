import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ServicesView extends ConsumerStatefulWidget {
  const ServicesView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ServicesViewState();
}

class _ServicesViewState extends ConsumerState<ServicesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Services",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              fontFamily: GoogleFonts.unbounded().fontFamily),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 6),
            child: IconButton(
                onPressed: () {
                  //TODO: ADD NOTIFICATION PAGE NAVIGATION
                },
                icon: const Icon(
                  Icons.notifications_outlined,
                  size: 28,
                  weight: 300,
                  color: Colors.black,
                )),
          ),
        ],
      ),
      body: const Center(child: Text("Services")),
    );
  }
}
