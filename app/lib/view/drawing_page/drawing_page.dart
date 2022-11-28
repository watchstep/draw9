import 'package:app/constants.dart';
import 'package:app/theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
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
  String label = 'monkey';

  @override
  void initState() {
    scribbleNotifier = ScribbleNotifier();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(65),
          child: Padding(
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
            Expanded(
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
                child: SizedBox(
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
                child: AutoSizeText(
                  'Is it\n'
                  '$label..?',
                  style: textTheme().headline2,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: Column(
                children: [
                  _buildColorToolbar(context),
                  const Divider(
                    height: 32,
                  ),
                  _buildStrokeToolbar(context),
                ],
              ),
            )
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: FloatingActionButton(
            onPressed: () {
              _saveImage(context);
            },
            backgroundColor: Colors.white,
            child: Image.asset('assets/images/sun.png'),
          ),
        ),
      ),
    );
  }

  Future<void> _saveImage(BuildContext context) async {
    final image = await scribbleNotifier.renderImage();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Save Your Drawing!',
          style: textTheme().headline2,
        ),
        content: Image.memory(image.buffer.asUint8List()),
      ),
    );
  }

  Widget _buildStrokeToolbar(BuildContext context) {
    return StateNotifierBuilder<ScribbleState>(
      stateNotifier: scribbleNotifier,
      builder: (context, state, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (final w in scribbleNotifier.widths)
            _buildStrokeButton(
              context,
              strokeWidth: w,
              state: state,
            ),
        ],
      ),
    );
  }

  Widget _buildStrokeButton(
    BuildContext context, {
    required double strokeWidth,
    required ScribbleState state,
  }) {
    final selected = state.selectedWidth == strokeWidth;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Material(
        elevation: selected ? 4 : 0,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () => scribbleNotifier.setStrokeWidth(strokeWidth),
          customBorder: const CircleBorder(),
          child: AnimatedContainer(
            duration: kThemeAnimationDuration,
            width: strokeWidth * 2,
            height: strokeWidth * 2,
            decoration: BoxDecoration(
                color: state.map(
                  drawing: (s) => Color(s.selectedColor),
                  erasing: (_) => Colors.transparent,
                ),
                border: state.map(
                  drawing: (_) => null,
                  erasing: (_) => Border.all(width: 1),
                ),
                borderRadius: BorderRadius.circular(50.0)),
          ),
        ),
      ),
    );
  }

  Widget _buildColorToolbar(BuildContext context) {
    return StateNotifierBuilder<ScribbleState>(
      stateNotifier: scribbleNotifier,
      builder: (context, state, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildUndoButton(context),
          const Divider(
            height: 4.0,
          ),
          _buildRedoButton(context),
          const Divider(
            height: 4.0,
          ),
          _buildClearButton(context),
          const Divider(
            height: 20.0,
          ),
          _buildEraserButton(context, isSelected: state is Erasing),
          _buildColorButton(context, color: Colors.black, state: state),
          _buildColorButton(context, color: Colors.red, state: state),
          _buildColorButton(context, color: Colors.green, state: state),
          _buildColorButton(context, color: Colors.blue, state: state),
          _buildColorButton(context, color: Colors.yellow, state: state),
        ],
      ),
    );
  }

  Widget _buildEraserButton(BuildContext context, {required bool isSelected}) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: FloatingActionButton.small(
        tooltip: "Erase",
        backgroundColor: const Color(0xFFF7FBFF),
        elevation: isSelected ? 10 : 2,
        shape: !isSelected
            ? const CircleBorder()
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
        child: const Icon(Icons.remove, color: Colors.blueGrey),
        onPressed: scribbleNotifier.setEraser,
      ),
    );
  }

  Widget _buildColorButton(
    BuildContext context, {
    required Color color,
    required ScribbleState state,
  }) {
    final isSelected = state is Drawing && state.selectedColor == color.value;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: FloatingActionButton.small(
          backgroundColor: color,
          elevation: isSelected ? 10 : 2,
          shape: !isSelected
              ? const CircleBorder()
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
          child: Container(),
          onPressed: () => scribbleNotifier.setColor(color)),
    );
  }

  Widget _buildUndoButton(
    BuildContext context,
  ) {
    return FloatingActionButton.small(
      tooltip: "Undo",
      onPressed: scribbleNotifier.canUndo ? scribbleNotifier.undo : null,
      disabledElevation: 0,
      backgroundColor: scribbleNotifier.canUndo ? Colors.blueGrey : Colors.grey,
      child: const Icon(
        Icons.undo_rounded,
        color: Colors.white,
      ),
    );
  }

  Widget _buildRedoButton(
    BuildContext context,
  ) {
    return FloatingActionButton.small(
      tooltip: "Redo",
      onPressed: scribbleNotifier.canRedo ? scribbleNotifier.redo : null,
      disabledElevation: 0,
      backgroundColor: scribbleNotifier.canRedo ? Colors.blueGrey : Colors.grey,
      child: const Icon(
        Icons.redo_rounded,
        color: Colors.white,
      ),
    );
  }

  Widget _buildClearButton(BuildContext context) {
    return FloatingActionButton.small(
      tooltip: "Clear",
      onPressed: scribbleNotifier.clear,
      disabledElevation: 0,
      backgroundColor: Colors.blueGrey,
      child: const Icon(Icons.clear),
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
