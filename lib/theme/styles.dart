import 'package:flutter/material.dart';

class Styles {
  static const OutlineInputBorder inputBorderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Colors.black, width: 1.5));

  static const OutlineInputBorder enabledInputBorderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Colors.green, width: 1.5));
}
