import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FreshKartLayout extends ConsumerStatefulWidget {
  const FreshKartLayout({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FreshKartLayoutState();
}

class _FreshKartLayoutState extends ConsumerState<FreshKartLayout> {
  @override
  Widget build(BuildContext context) {
    return const Text("FRESHKART");
  }
}
