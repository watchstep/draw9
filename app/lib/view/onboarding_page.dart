import 'package:app/constants.dart';
import 'package:app/view/drawing_page/drawing_page.dart';
import 'package:app/theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/outside.png"),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: size.height * .02),
              child: draw9AppBar(),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: size.height * .03),
              child: Image.asset(
                'assets/images/cloud.png',
                scale: 4,
              ),
            ),
            _aboutDraw9(size),
            Spacer(),
            Image.asset(
              'assets/images/UMA_hello.png',
              scale: 3,
            ),
            _getStartedSlider(size),
          ],
        ),
      ),
    ));
  }

  Widget _getStartedSlider(Size size) {
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

  Widget _aboutDraw9(Size size) {
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
}
