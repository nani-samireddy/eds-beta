import 'package:flutter/material.dart';

class Styles {
  static const OutlineInputBorder disabledInputBorderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide:
          BorderSide(color: Color.fromARGB(255, 125, 120, 120), width: 1.5));

  static const OutlineInputBorder inputBorderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 1.5));

  static const OutlineInputBorder enabledInputBorderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Colors.green, width: 1.5));
}
