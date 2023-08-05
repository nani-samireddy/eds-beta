import 'package:flutter/material.dart';

class PagePadding extends StatefulWidget {
  const PagePadding({super.key, required this.child});
  final Widget child;

  @override
  State<PagePadding> createState() => _PagePaddingState();
}

class _PagePaddingState extends State<PagePadding> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: widget.child);
  }
}
