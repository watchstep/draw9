import 'package:app/view/onboarding_page.dart';
import 'package:app/theme.dart';
import 'package:app/view/onboarding_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Draw9());
}

class Draw9 extends StatelessWidget {
  const Draw9({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Draw9',
      debugShowCheckedModeBanner: false,
      theme: theme(),
      home: const OnboardingPage(),
    );
  }
}
