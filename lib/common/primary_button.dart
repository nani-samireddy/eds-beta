import 'package:eds_beta/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final Function() onPressed;
  final bool enable;
  const PrimaryButton(
      {required this.text,
      required this.onPressed,
      this.enable = true,
      super.key});

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool buttonFocused = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // widget.enable
        //     ? Container(
        //         margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        //         width: double.infinity,
        //         height: 54,
        //         decoration: BoxDecoration(
        //           color: Pallete.primaryButtonShadowColor,
        //           borderRadius: BorderRadius.circular(16),
        //           border: Border.all(color: Colors.black, width: 2),
        //         ),
        //       )
        //     : const SizedBox.shrink(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.enable ? widget.onPressed : null,
            style: ButtonStyle(
              side: const MaterialStatePropertyAll<BorderSide>(
                BorderSide(color: Colors.black, width: 1),
              ),
              shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                  Pallete.primaryButtonBackgroundColor),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
              ),
            ),
            child: Text(
              widget.text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  letterSpacing: 1.3,
                  fontFamily: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                  ).fontFamily),
            ),
          ),
        ),
      ],
    );
  }
}
