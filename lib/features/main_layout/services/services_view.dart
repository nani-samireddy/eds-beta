import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServicesView extends ConsumerStatefulWidget {
  const ServicesView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ServicesViewState();
}

class _ServicesViewState extends ConsumerState<ServicesView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Services")),
    );
  }
}
