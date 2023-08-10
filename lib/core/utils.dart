import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(minutes: 1),
      content: Text(
        content,
      ),
    ),
  );
}

String calculateDiscount(
    {required double actualPrice, required double currentPrice}) {
  return ((currentPrice / actualPrice) * 100).toString().substring(0, 4);
}

List<TableRow> formatProductDetails({required String details}) {
  List<TableRow> rows = [];
  List<String> detailsList = details.split(';');
  for (var element in detailsList) {
    List<String> row = element.split(':');
    if (row.length != 2) {
      continue;
    }
    rows.add(
      TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              row[0],
              softWrap: true,
              maxLines: 4,
              style: TextStyle(
                fontSize: 12,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    ' ${row[1]} ${row[1]}',
                    softWrap: true,
                    maxLines: 4,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  return rows;
}
