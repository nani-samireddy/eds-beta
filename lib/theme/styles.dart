import 'package:flutter/material.dart';

class Styles {
  static const OutlineInputBorder inputBorderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(0)),
      borderSide: BorderSide(color: Colors.black, width: 1));

  static const OutlineInputBorder enabledInputBorderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(0)),
      borderSide: BorderSide(color: Colors.green, width: 1));
}
