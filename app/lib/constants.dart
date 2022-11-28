import 'package:app/theme.dart';
import 'package:flutter/material.dart';

const primaryColor = Color(0xff252526);
const secondaryColor = Color(0xff3e3e42);
const backgroundColor = Color(0xffe7eff6);

Widget draw9AppBar() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset(
        'assets/images/sun.png',
        scale: 18,
      ),
      const SizedBox(
        width: 10,
      ),
      Text(
        'Draw9',
        style: textTheme().headline2,
      ),
    ],
  );
}