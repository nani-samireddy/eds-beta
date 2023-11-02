import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eds_beta/models/app_models.dart';
import 'package:google_fonts/google_fonts.dart';

class OfferDetailedView extends ConsumerStatefulWidget {
  const OfferDetailedView({super.key, required this.offer});
  final Offer offer;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OfferDetailedViewState();
}

class _OfferDetailedViewState extends ConsumerState<OfferDetailedView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 32,
              weight: 700,
              color: Colors.black,
            )),
        title: Text(
          widget.offer.name,
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontFamily: GoogleFonts.unbounded().fontFamily),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(widget.offer.image),
            Markdown(
                data: widget.offer.description,
                shrinkWrap: true,
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: GoogleFonts.dmSans().fontFamily,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
