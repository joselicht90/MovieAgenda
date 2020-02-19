import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:reorderables/reorderables.dart';

class NotesHome extends StatefulWidget {
  @override
  _NotesHomeState createState() => _NotesHomeState();
}

class _NotesHomeState extends State<NotesHome> {
  TextEditingController _textController = TextEditingController();
  List<TextSpan> _spans = [TextSpan(text: 'Hola que tal como les va?')];

  void _editionListener() {
    setState(() {
      // if (!_textController.selection.isCollapsed) {
      //   String subString = print(
      //       '${_textController.selection.start.toString()} - ${_textController.selection.end.toString()}');
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.arrow_back,
                  color: Colors.grey.shade500,
                  size: 20,
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: TextField(
                maxLines: null,
                style: TextStyle(fontSize: 25, color: Colors.grey.shade200),
                decoration: InputDecoration(
                    disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    hintText: 'Title',
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 25)),
              ),
            ),
            Divider(),
            NotificationListener(
              onNotification: (notification){
                var n = notification;
                return true;
              },
              child: SelectableText.rich(
                TextSpan(
                  text: 'HOLA QUE TAL',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade200),
                    children: []),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends TextField {}
