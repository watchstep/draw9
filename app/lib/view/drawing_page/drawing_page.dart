import 'package:app/constants.dart';
import 'package:app/theme.dart';
import 'package:app/view/drawing_page/widgets/drawing_menu.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scribble/scribble.dart';
import 'package:http/http.dart' as http;

class DrawingPage extends StatefulWidget {
  const DrawingPage({Key? key}) : super(key: key);

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  late ScribbleNotifier scribbleNotifier;
  late String label;
  bool isFABClose = true;
  late String labelName;
  late var image;

  @override
  void initState() {
    scribbleNotifier = ScribbleNotifier();
    super.initState();
  }

  Future postDrawing() async {
    var request = http.MultipartRequest(
        "POST", Uri.parse('http://7c1c-165-132-5-141.ngrok.io/'));

    final headers = {"Content-type": "multipart/form-data"};

    request.files.add(http.MultipartFile.fromBytes(
        'img', image.readAsByteSync(),
        filename: 'drawing'));

    request.headers.addAll(headers);

    var res = await request.send();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(65),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: size.height * .02),
              child: Stack(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 30,
                      )),
                  Align(alignment: Alignment.topCenter, child: draw9AppBar()),
                ],
              ),
            ),
          ),
          body: Stack(
            children: [
              SizedBox(
                width: size.width,
                height: size.height * .75,
                child: Scribble(
                  notifier: scribbleNotifier,
                  drawPen: true,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.white,
                  height: size.height * .25,
                ),
              ),
              Positioned(
                  left: 15,
                  bottom: 20,
                  child: Container(
                    width: size.width * .3,
                    child: Image.asset(
                      'assets/images/UMA_plain.png',
                    ),
                  )),
              Positioned(
                left: size.width * .32,
                top: size.height * .65,
                child: Container(
                  constraints: BoxConstraints(maxWidth: size.width * .4),
                  padding: const EdgeInsets.all(3),
                  child:
                      FutureBuilder(builder: (context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) return CircularProgressIndicator();
                    return ChangeNotifierProvider<
                        ValueNotifier<ScribbleNotifier>>(
                      create: (_) {
                        return ValueNotifier(snapshot.data);
                      },
                      child: AutoSizeText(
                        'Is it\n'
                        '$label..?',
                        style: textTheme().headline2,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                      ),
                    );
                  }),
                ),
              ),
              isFABClose == true
                  ? Positioned(
                      right: 16,
                      bottom: 75,
                      child: menuBar(context, label, size))
                  : SizedBox(),
            ],
          ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    isFABClose = !isFABClose;
                  });
                },
                child: Image.asset('assets/images/sun.png'),
                backgroundColor: Colors.white,
              ),
            ],
          )),
    );
  }

  Widget menuBar(BuildContext context, String label, Size size) {
    return StateNotifierBuilder<ScribbleState>(
      stateNotifier: scribbleNotifier,
      builder: (context, state, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          saveButton(scribbleNotifier, context, label, size),
          const Divider(
            height: 4.0,
          ),
          undoButton(scribbleNotifier, context),
          const Divider(
            height: 4.0,
          ),
          redoButton(scribbleNotifier, context),
          const Divider(
            height: 4.0,
          ),
          clearButton(scribbleNotifier, context),
          const Divider(
            height: 4.0,
          ),
          eraserButton(scribbleNotifier, context, state,
              isSelected: state is Erasing),
          colorButton(scribbleNotifier, context,
              color: Colors.black, state: state),
          colorButton(scribbleNotifier, context,
              color: Colors.red, state: state),
          colorButton(scribbleNotifier, context,
              color: Colors.yellow, state: state),
          colorButton(scribbleNotifier, context,
              color: Colors.blue, state: state),
        ],
      ),
    );
  }
}
