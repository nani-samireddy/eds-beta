import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrdersOptions extends ConsumerStatefulWidget {
  const OrdersOptions({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrdersOptionsState();
}

class _OrdersOptionsState extends ConsumerState<OrdersOptions> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [Text("Orders")],
    );
  }
}
