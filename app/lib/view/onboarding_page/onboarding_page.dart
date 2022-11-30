import 'package:app/constants.dart';

import 'package:app/view/onboarding_page/widgets/about_draw9.dart';
import 'package:app/view/onboarding_page/widgets/get_started_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
            aboutDraw9(size),
            Spacer(),
            Image.asset(
              'assets/images/UMA_hello.png',
              scale: 3,
            ),
            getStartedSlider(context, size),
          ],
        ),
      ),
    ));
  }
}
