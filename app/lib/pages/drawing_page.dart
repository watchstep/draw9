import 'package:app/constants.dart';
import 'package:app/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribble/scribble.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({Key? key}) : super(key: key);

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  late ScribbleNotifier scribbleNotifier;

  @override
  void initState() {
    scribbleNotifier = ScribbleNotifier();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                child: Scribble(
              notifier: scribbleNotifier,
              drawPen: true,
            )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  colorPalette(Colors.black),
                  colorPalette(Colors.red),
                  colorPalette(Colors.orange),
                  colorPalette(Colors.blue),
                  colorPalette(Colors.green),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Slider(
                value: 3,
                onChanged: (thickness) {},
                min: 3,
                max: 15,
              ),
            ),
            Text(
              'Eraser',
              style: textTheme().headline3,
            ),
          ],
        ),
      ),
    );
  }

  Widget colorPalette(Color color) {
    return GestureDetector(
      // child 크기 전체를 touch 범위로 지정
      // behavior : HitTestBehavior.opaque => 빈 공간도 touch 범위로 지정
      behavior: HitTestBehavior.translucent,
      onTap: () {},
      child: CircleAvatar(
        backgroundColor: color,
        radius: 22,
        child: CircleAvatar(
          radius: 19,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 17,
            backgroundColor: color,
          ),
        ),
      ),
    );
  }
}
