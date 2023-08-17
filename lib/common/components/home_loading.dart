import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircularSKLoader extends StatelessWidget {
  const CircularSKLoader(
      {super.key, required this.height, required this.width});
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 205, 205, 205),
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}

class RectangularSKLOader extends StatelessWidget {
  const RectangularSKLOader(
      {super.key, required this.height, required this.width});
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 205, 205, 205),
        borderRadius: BorderRadius.circular(40),
      ),
    );
  }
}
