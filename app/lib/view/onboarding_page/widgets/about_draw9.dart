import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

Widget aboutDraw9(Size size) {
  return Container(
    width: size.width * .9,
    constraints: BoxConstraints(maxHeight: size.height * .11),
    child: AutoSizeText(
      'Hello, Draw9 is an app that can guess what you drew!',
      style: TextStyle(fontSize: 21, fontFamily: 'MilkyBoba'),
      textAlign: TextAlign.center,
    ),
  );
}