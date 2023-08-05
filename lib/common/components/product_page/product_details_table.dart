import 'package:eds_beta/core/core.dart';
import 'package:eds_beta/theme/theme.dart';
import 'package:flutter/material.dart';

class ProductDetailsTable extends StatelessWidget {
  ProductDetailsTable({super.key, required this.details}) {
    rows = formatProductDetails(details: details);
  }
  final String details;
  late final List<TableRow> rows;

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(),
      border: TableBorder.all(
          color: Pallete.fadedIconColor.withOpacity(.4),
          borderRadius: BorderRadius.circular(12)),
      children: [
        const TableRow(children: [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              "Name",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )
        ]),
        ...rows,
      ],
    );
  }
}
