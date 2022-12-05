import 'package:app/constants.dart';
import 'package:app/theme.dart';
import 'package:app/view/drawing_page/drawing_page.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

Widget getStartedSlider(BuildContext context, Size size) {
  return Padding(
    padding:
        EdgeInsets.only(top: size.height * .035, bottom: size.height * .04),
    child: ConfirmationSlider(
      onConfirmation: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DrawingPage()),
        );
      },
      height: size.height * .08,
      text: '   Let\'s draw!',
      sliderButtonContent: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 25,
        color: Colors.white,
      ),
      width: size.width * .75,
      shadow: BoxShadow(
        color: Colors.grey.withOpacity(.3),
        blurRadius: 3,
        spreadRadius: 1,
      ),
      backgroundShape: BorderRadius.all(Radius.circular(50)),
      textStyle: textTheme().headline2,
      foregroundColor: primaryColor,
    ),
  );
}
