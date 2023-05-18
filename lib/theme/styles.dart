import 'package:flutter/material.dart';

class Styles {
  static const OutlineInputBorder inputBorderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Colors.grey, width: 1));

  static const OutlineInputBorder enabledInputBorderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Colors.green, width: 2));
}
