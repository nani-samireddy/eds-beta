import 'package:eds_beta/common/circular_loader.dart';
import 'package:flutter/material.dart';

class CircularLoaderPage extends StatelessWidget {
  final String message;
  const CircularLoaderPage(
      {this.message = "",
      this.backgroundColor = const Color.fromARGB(126, 0, 0, 0),
      super.key});
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
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
