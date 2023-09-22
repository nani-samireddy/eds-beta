import 'package:eds_beta/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SortAndFilterProducts extends ConsumerStatefulWidget {
  const SortAndFilterProducts(
      {super.key, required this.handleSort, required this.handleFilter});
  final void Function() handleSort;
  final void Function() handleFilter;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SortAndFilterProductsState();
}

class _SortAndFilterProductsState extends ConsumerState<SortAndFilterProducts> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Pallete.white,
      child: Row(
        children: [
          Expanded(
            child: TextButton.icon(
              onPressed: widget.handleSort,
              icon: const Icon(
                Icons.sort,
                color: Pallete.black,
              ),
              label: const Text(
                'Sort',
                style: TextStyle(color: Pallete.black),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextButton.icon(
              onPressed: widget.handleFilter,
              icon: const Icon(
                Icons.filter_alt_outlined,
                color: Pallete.black,
              ),
              label: const Text(
                'Filter',
                style: TextStyle(color: Pallete.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
