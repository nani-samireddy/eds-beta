import 'package:eds_beta/common/circular_loader.dart';
import 'package:flutter/material.dart';

class CircularLoaderPage extends StatelessWidget {
  final String message;
  const CircularLoaderPage({this.message = "", super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(126, 0, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircularLoader(),
          Text(message),
        ],
      ),
    );
  }
}
