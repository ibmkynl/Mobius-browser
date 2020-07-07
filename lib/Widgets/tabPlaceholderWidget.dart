import 'package:flutter/material.dart';
import 'package:mobius_browser/constants.dart';

Widget tabPlaceHolderWidget() {
  return Container(
    color: Colors.white,
    child: Center(
      child: Icon(
        Icons.public,
        size: 75,
        color: kGradientEndColor,
      ),
    ),
  );
}
