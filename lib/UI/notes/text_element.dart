import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:movie_agenda/BLoC/new_note_bloc.dart';
import 'package:reorderables/reorderables.dart';

abstract class DocElement extends StatelessWidget {
  int id;
  DocElement({@required this.id, Key key}) : super(key: key);

}



abstract class TextElement extends DocElement {
  NewNoteBloc bloc;
  int id;
  String hint;
  TextEditingController controller = TextEditingController();
  ValueNotifier<int> counter = ValueNotifier<int>(0);
  TextStyle style;
  Function(dynamic) setFocus;
  Function unsetFocus;
  TextElement(
      {@required this.bloc,
      @required id,
      @required this.style,
      @required this.hint,
      @required this.setFocus,
      @required this.unsetFocus,
      this.counter,
      Key key})
      : super(key: key, id: id);

  void setStyle(TextStyle s) {
    this.style = s;
  }
}

class ParagraphElement extends TextElement {
  ValueNotifier<int> counter = ValueNotifier<int>(0);
  ParagraphElement(
      {@required NewNoteBloc bloc,
      @required int id,
      @required TextStyle style,
      @required String hint,
      @required Function(dynamic) setFocus,
      @required Function unsetFocus,
      Key key})
      : super(
            key: key,
            bloc: bloc,
            id: id,
            style: style,
            hint: hint,
            setFocus: setFocus,
            unsetFocus: unsetFocus);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: counter,
      builder: (context, value, child) {
        return Container(
          color: Colors.transparent,
          child: TextField(
            onEditingComplete: () {
              unsetFocus();
            },
            onTap: () {
              setFocus(this);
            },
            onSubmitted: (p){
              print('yolo');
            },
            //textInputAction: TextInputAction.done,
            keyboardAppearance: DynamicTheme.of(context).brightness,
            maxLines: null,
            //autofocus: true,
            keyboardType: TextInputType.multiline,
            enableInteractiveSelection: true,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                fillColor: Colors.transparent),
            controller: controller,
            style: style,
            cursorColor: Colors.green,
          ),
        );
      },
    );
  }
}

class TitleElement extends TextElement {
  ValueNotifier<int> counter = ValueNotifier<int>(0);
  TitleElement(
      {@required NewNoteBloc bloc,
      @required int id,
      @required TextStyle style,
      @required String hint,
      @required Function(dynamic) setFocus,
      @required Function unsetFocus,
      Key key})
      : super(
            key: key,
            bloc: bloc,
            id: id,
            style: style,
            hint: hint,
            setFocus: setFocus,
            unsetFocus: unsetFocus);

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
            setFocus(this);
          },
          textInputAction: TextInputAction.done,
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
      },
    );
  }
}

class DragTargetRow extends StatelessWidget {
  int id;
  NewNoteBloc bloc;
  List<dynamic> children = [];
  ValueNotifier<int> counter = ValueNotifier<int>(0);
  Color _dragColor = Colors.transparent;
  DragTargetRow({@required this.id, @required this.bloc, Key key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    void _onReorder(int oldIndex, int newIndex) {
      Widget col = children.removeAt(oldIndex);
      children.insert(newIndex, col);
      counter.value++;
    }

    return ValueListenableBuilder(
      valueListenable: counter,
      builder: (context, value, child) {
        return DragTarget<dynamic>(
          builder: (context, candidateData, rejectedData) {
            return children.length > 0
                ? ReorderableRow(
                    buildDraggableFeedback: (context, constraints, child) {
                      return Icon(Icons.move_to_inbox, color: Colors.white, size: 50,);
                    },
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    scrollController: ScrollController(),
                    children: children.map<Widget>((e) => e).toList(),
                    onReorder: _onReorder,
                    mainAxisSize: MainAxisSize.max,
                    needsLongPressDraggable: false,
                  )
                : Container(
                    color: _dragColor,
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 150,
                    child: Center(
                      child: Text('Insert elements'),
                    ),
                  );
          },
          onWillAccept: (data) {
            _dragColor = Colors.white.withOpacity(0.3);
            if (!children.contains((element) => element.child == data)) {
              if (children.length == 1) {
                Container c = Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: children.first.child,
                  key: children.first.key,
                );
                children[0] = c;
              }
              return children.length < 3 ? true : false;
            }
            return false;
          },
          onLeave: (data) {
            if (!children.contains((element) => element.child == data)) {
              if (children.length == 1) {
                Container c = Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: children.first.child,
                  key: children.first.key,
                );
                children[0] = c;
              }
            }

            _dragColor = Colors.transparent;
          },
          onAccept: (data) {
            _dragColor = Colors.transparent;
            children.add(
              Container(
                width: children.length == 0
                    ? MediaQuery.of(context).size.width * 0.8
                    : MediaQuery.of(context).size.width * 0.4,
                child: data,
                key: Key('cont'),
              ),
            );
            //widget.bloc.addElement(data);
          },
        );
      },
    );
  }
}
