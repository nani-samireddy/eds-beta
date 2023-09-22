import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HelpOptions extends ConsumerStatefulWidget {
  const HelpOptions({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HelpOptionsState();
}

class _HelpOptionsState extends ConsumerState<HelpOptions> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [Text("Help Options")],
    );
  }
}
