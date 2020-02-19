import 'dart:ui';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:movie_agenda/BLoC/interface/bloc_provider.dart';
import 'package:movie_agenda/BLoC/new_doc_bloc.dart';
import 'package:reorderables/reorderables.dart';

class NotesHome extends StatefulWidget {
  @override
  _NotesHomeState createState() => _NotesHomeState();
}

class _NotesHomeState extends State<NotesHome> {
  List<TextElement> _tiles = [];
  List<TextElementController> _controllers = [];
  Color _dragColor = Colors.transparent;
  bool _isDragging = false;
  Color floatColor = Color(0xFFec625f);
  TextElement _currentElement;

  NewDocumentBloc _bloc = NewDocumentBloc();

  @override
  void initState() {
    super.initState();
    _bloc.getStyles();
  }

  _setInputFocus(int id) {
    setState(() {
      _currentElement = _tiles.singleWhere((element) => element.id == id);
    });
  }

  _unsetInputFocus() {
    setState(() {
      _currentElement = null;
      FocusScope.of(context).requestFocus(new FocusNode());
    });
  }

  _changeStyle() {}

  @override
  Widget build(BuildContext context) {
    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        TextElement tile = _tiles.removeAt(oldIndex);
        _tiles.insert(newIndex, tile);
        _isDragging = false;
        floatColor = Color(0xFFec625f);
      });
    }

    return Scaffold(
      body: BlocProvider(
        bloc: _bloc,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: _dragColor,
                  child: DragTarget<TextElement>(
                    builder: (context, candidateData, rejectedData) {
                      return ReorderableWrap(
                        onReorderStarted: (_) {
                          _isDragging = true;
                        },
                        spacing: 8.0,
                        runSpacing: 4.0,
                        needsLongPressDraggable: false,
                        padding: const EdgeInsets.all(8),
                        children: _tiles,
                        onReorder: _onReorder,
                        onNoReorder: (int index) {
                          _isDragging = false;
                          //floatColor = Color(0xFFec625f);
                        },
                      );
                    },
                    onWillAccept: (data) {
                      setState(() {
                        _dragColor = Colors.white.withOpacity(0.3);
                      });
                      return true;
                    },
                    onLeave: (data) {
                      setState(() {
                        _dragColor = Colors.transparent;
                      });
                    },
                    onAccept: (data) {
                      _bloc.addController(TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30));
                      setState(() {
                        TextElement t = data;
                        _currentElement = t;
                        _tiles.add(data);
                        _dragColor = Colors.transparent;
                      });
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: !_isDragging && _currentElement != null
                        ? FloatingActionButton.extended(
                            onPressed: () => _changeStyle(),
                            label: Text('Tools'),
                            icon: Icon(Icons.settings),
                          )
                        : Container(),
                  ),
                ],
              ),
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                child: _isDragging
                    ? DragTarget<int>(
                        builder: (context, x, y) {
                          return FloatingActionButton.extended(
                            onPressed: null,
                            label: Text('Remove'),
                            icon: Icon(Icons.delete),
                          );
                        },
                        onWillAccept: (data) {
                          setState(() {
                            floatColor = Color(0xFFec625f).withOpacity(0.5);
                          });
                          return true;
                        },
                        onLeave: (data) {
                          setState(() {
                            floatColor = Color(0xFFec625f);
                          });
                        },
                        onAccept: (data) {
                          setState(() {
                            _isDragging = false;
                            floatColor = Color(0xFFec625f);
                            _tiles.removeAt(data);
                          });
                        },
                      )
                    : Container(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Draggable<TextElement>(
              child: Icon(
                Icons.text_fields,
                color: Colors.white,
                size: 50,
              ),
              feedback: Icon(
                Icons.text_fields,
                color: Colors.white.withOpacity(0.5),
                size: 50,
              ),
              data: TextElement(
                bloc: _bloc,
                unsetFocus: _unsetInputFocus,
                setFocus: _setInputFocus,
                id: _tiles.length,
                key: Key('${_tiles.length}-title'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextElement extends StatefulWidget {
  final NewDocumentBloc bloc;
  final int id;
  final TextEditingController controller = TextEditingController();
  final Function(int) setFocus;
  final Function unsetFocus;
  TextElement(
      {@required this.bloc,
      @required this.id,
      @required this.setFocus,
      @required this.unsetFocus,
      Key key})
      : super(key: key);
  @override
  _TextElementState createState() => _TextElementState();
}

class _TextElementState extends State<TextElement> {
  TextStyle _default =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: widget.bloc.getStream(widget.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          TextStyle style = snapshot.data;
          return TextField(
            onEditingComplete: () {
              widget.unsetFocus();
            },
            onTap: () {
              widget.setFocus(widget.id);
            },
            autofocus: true,
            enableInteractiveSelection: true,
            decoration: InputDecoration(border: InputBorder.none),
            controller: widget.controller,
            style: style ?? _default,
            cursorColor: Colors.green,
          );
        }
        return Container();
      },
    );
  }
}

class TextElementController {
  String id;
  TextEditingController controller;

  TextElementController({@required this.id, @required this.controller});
}
