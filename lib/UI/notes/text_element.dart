import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:movie_agenda/BLoC/new_doc_bloc.dart';

class TextElement extends StatelessWidget {
  NewDocumentBloc bloc;
  int id;
  String hint;
  TextEditingController controller = TextEditingController();
  TextStyle style;
  Function(int) setFocus;
  Function unsetFocus;
  TextElement(
      {@required this.bloc,
      @required this.id,
      @required this.style,
      @required this.hint,
      @required this.setFocus,
      @required this.unsetFocus,
      Key key})
      : super(key: key);
  ValueNotifier<int> counter = ValueNotifier<int>(0);

  TextStyle _default =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: counter,
        builder: (context, value, child) {
          return TextField(
            onEditingComplete: () {
              unsetFocus();
            },
            onTap: () {
              setFocus(id);
            },
            //textInputAction: TextInputAction.done,
            keyboardAppearance: DynamicTheme.of(context).brightness,
            maxLines: null,
            //autofocus: true,
            keyboardType: TextInputType.multiline,
            enableInteractiveSelection: true,
            decoration: InputDecoration(border: InputBorder.none, hintText: hint),
            controller: controller,
            style: style,
            cursorColor: Colors.green,
          );
        });
    // return Stack(
    //   children: <Widget>[

    //   ],
    // );
  }
}

// class TextElement extends StatefulWidget {
//   final NewDocumentBloc bloc;
//   final int id;
//   final TextEditingController controller = TextEditingController();
//   final Function(int) setFocus;
//   final Function unsetFocus;
//   TextElement(
//       {@required this.bloc,
//       @required this.id,
//       @required this.setFocus,
//       @required this.unsetFocus,
//       Key key})
//       : super(key: key);
//   @override
//   _TextElementState createState() => _TextElementState();
// }

// class _TextElementState extends State<TextElement> {
//   TextStyle _default =
//       TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30);

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       onEditingComplete: () {
//         widget.unsetFocus();
//       },
//       onTap: () {
//         widget.setFocus(widget.id);
//       },
//       autofocus: true,
//       enableInteractiveSelection: true,
//       decoration: InputDecoration(border: InputBorder.none),
//       controller: widget.controller,
//       style: _default,
//       cursorColor: Colors.green,
//     );
//   }
// }
