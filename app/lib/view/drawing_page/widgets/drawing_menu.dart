import 'package:app/constants.dart';
import 'package:app/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:scribble/scribble.dart';

FloatingActionButton saveButton(ScribbleNotifier scribbleNotifier,
    BuildContext context, String label, Size size) {
  return FloatingActionButton.small(
    onPressed: () {
      _saveImage(scribbleNotifier, label, context, size);
    },
    child: Icon(
      CupertinoIcons.square_arrow_up,
      size: 20,
      color: primaryColor,
    ),
    backgroundColor: Colors.white,
  );
}

Future<void> _saveImage(ScribbleNotifier scribbleNotifier, String label,
    BuildContext context, Size size) async {
  final image = await scribbleNotifier.renderImage();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Save Your Drawings!',
              style: textTheme().headline2,
            ),
          ),
          Image.memory(image.buffer.asUint8List()),
        ],
      ),
      actions: [
        InkWell(
            onTap: () async {
              try {
                await ImageGallerySaver.saveImage(image.buffer.asUint8List(),
                    name: label + '.png', isReturnImagePathOfIOS: true);
              } catch (e) {
                debugPrint(e.toString());
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                'save',
                style: TextStyle(
                    fontSize: textTheme().headline3?.fontSize,
                    color: Colors.blue,
                    fontFamily: textTheme().headline3?.fontFamily),
              ),
            )),
        GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text(
                'undo',
                style: TextStyle(
                    fontSize: textTheme().headline3?.fontSize,
                    color: Colors.red,
                    fontFamily: textTheme().headline3?.fontFamily),
              ),
            ))
      ],
    ),
  );
}

Widget eraserButton(
    ScribbleNotifier scribbleNotifier, BuildContext context, state,
    {required bool isSelected}) {
  return Padding(
    padding: const EdgeInsets.all(4),
    child: FloatingActionButton.small(
      backgroundColor: Colors.white,
      elevation: isSelected ? 10 : 5,
      shape: !isSelected
          ? const CircleBorder()
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
      child: Icon(
        CupertinoIcons.minus,
        color: primaryColor,
        size: 20,
      ),
      onPressed: scribbleNotifier.setEraser,
    ),
  );
}

Widget colorButton(
  ScribbleNotifier scribbleNotifier,
  BuildContext context, {
  required Color color,
  required ScribbleState state,
}) {
  final isSelected = state is Drawing && state.selectedColor == color.value;
  return Padding(
    padding: const EdgeInsets.all(4),
    child: FloatingActionButton.small(
        backgroundColor: color,
        elevation: isSelected ? 10 : 5,
        shape: const CircleBorder(),
        child: Container(
            margin: isSelected ? const EdgeInsets.all(3) : null,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                border: isSelected
                    ? Border.all(width: 1.5, color: Colors.white)
                    : null)),
        onPressed: () => scribbleNotifier.setColor(color)),
  );
}

Widget undoButton(
  ScribbleNotifier scribbleNotifier,
  BuildContext context,
) {
  return FloatingActionButton.small(
    onPressed: scribbleNotifier.canUndo ? scribbleNotifier.undo : null,
    backgroundColor: scribbleNotifier.canUndo ? primaryColor : Colors.white,
    child: Icon(
      CupertinoIcons.arrow_turn_up_left,
      size: 20,
      color: scribbleNotifier.canUndo ? Colors.white : primaryColor,
    ),
  );
}

Widget redoButton(
  ScribbleNotifier scribbleNotifier,
  BuildContext context,
) {
  return FloatingActionButton.small(
    onPressed: scribbleNotifier.canRedo ? scribbleNotifier.redo : null,
    backgroundColor: scribbleNotifier.canRedo ? primaryColor : Colors.white,
    child: Icon(
      CupertinoIcons.arrow_turn_up_right,
      size: 20,
      color: scribbleNotifier.canRedo ? Colors.white : primaryColor,
    ),
  );
}

Widget clearButton(ScribbleNotifier scribbleNotifier, BuildContext context) {
  return FloatingActionButton.small(
    onPressed: scribbleNotifier.clear,
    backgroundColor: Colors.white,
    child: const Icon(
      CupertinoIcons.xmark,
      size: 20,
      color: primaryColor,
    ),
  );
}
