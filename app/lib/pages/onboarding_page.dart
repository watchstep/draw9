import 'package:app/constants.dart';
import 'package:app/pages/drawing_page.dart';
import 'package:app/theme.dart';
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
    return SafeArea(
        child: Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Image.asset(
              'assets/images/cloud.png',
              scale: 4,
            ),
          ),
          Text(
            'Hello, Draw9 is an app that\n'
            'can guess what you drew!',
            style: TextStyle(fontSize: 19, fontFamily: 'MilkyBoba'),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 35,),
          Image.asset(
            'assets/images/UMA_hello.png',
            scale: 3,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 40),
            child: ConfirmationSlider(
              onConfirmation: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DrawingPage()),
                );
              },
              height: 65,
              text: '   Let\'s draw!',
              sliderButtonContent: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 25,
                color: Colors.white,
              ),
              width: 320,
              shadow: BoxShadow(
                color: Colors.grey.withOpacity(.3),
                blurRadius: 3,
                spreadRadius: 1,
              ),
              backgroundShape: BorderRadius.all(Radius.circular(50)),
              textStyle: textTheme().headline2,
              foregroundColor: primaryColor,
            ),
          ),
        ],
      ),
    ));
  }
}
