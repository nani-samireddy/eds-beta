import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LikedView extends ConsumerStatefulWidget {
  const LikedView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LikedViewState();
}

class _LikedViewState extends ConsumerState<LikedView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Liked")),
    );
  }
}
