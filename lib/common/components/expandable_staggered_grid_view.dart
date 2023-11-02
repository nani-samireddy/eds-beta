import 'package:eds_beta/core/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ExpandableStaggeredGridView extends StatefulWidget {
  const ExpandableStaggeredGridView({
    super.key,
    required this.items,
    required this.builder,
    this.title,
  });
  final String? title;
  final List<Object> items;
  final Widget Function(int index) builder;

  @override
  State<ExpandableStaggeredGridView> createState() =>
      _ExpandableStaggeredGridViewState();
}

class _ExpandableStaggeredGridViewState
    extends State<ExpandableStaggeredGridView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.title != null
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Text(widget.title!, style: AppStyles.sectionHeading),
              )
            : const SizedBox.shrink(),
        StaggeredGrid.count(
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          crossAxisCount: 2,
          children: widget.items
              .map((e) => widget.builder(widget.items.indexOf(e)))
              .toList(),
        ),
      ],
    );
  }
}
