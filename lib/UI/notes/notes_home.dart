import 'dart:ui';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:movie_agenda/BLoC/interface/bloc_provider.dart';
import 'package:movie_agenda/BLoC/new_doc_bloc.dart';
import 'package:movie_agenda/UI/notes/text_element.dart';
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
  int _idGenerator = 0;

  NewDocumentBloc _bloc = NewDocumentBloc();

  @override
  void initState() {
    super.initState();
    _bloc.getElements();
  }

  _setInputFocus(int id) {
    _bloc.setInputFocus(id);
  }

  _unsetInputFocus() {
    setState(() {
      _bloc.unsetInputFocus();
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    });
  }

  _changeStyle() {
    TextStyle s = TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 50);
    _bloc.updateStyle(s);
  }

  @override
  Widget build(BuildContext context) {
    void _onReorder(int oldIndex, int newIndex) {
      setState(() {
        _bloc.reorder(oldIndex, newIndex);
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
              StreamBuilder<Object>(
                  stream: _bloc.streamElements,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<TextElement> elements = snapshot.data;
                      return Expanded(
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: _dragColor,
                          child: DragTarget<TextElement>(
                            builder: (context, candidateData, rejectedData) {
                              return ReorderableWrap(
                                onReorderStarted: (_) {
                                  setState(() {
                                    _isDragging = true;
                                  });
                                },
                                spacing: 8.0,
                                runSpacing: 4.0,
                                needsLongPressDraggable: false,
                                padding: const EdgeInsets.all(8),
                                children: elements,
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
                              setState(() {
                                _idGenerator++;
                              });
                              _bloc.addElement(data);
                              _dragColor = Colors.transparent;
                            },
                          ),
                        ),
                      );
                    }
                    return Container();
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FloatingActionButton.extended(
                    onPressed: () => _changeStyle(),
                    label: Text('Tools'),
                    icon: Icon(Icons.settings),
                  )
                  // AnimatedSwitcher(
                  //   duration: Duration(milliseconds: 300),
                  //   child: !_isDragging && _bloc.currentElement != null
                  //       ? FloatingActionButton.extended(
                  //           onPressed: () => _changeStyle(),
                  //           label: Text('Tools'),
                  //           icon: Icon(Icons.settings),
                  //         )
                  //       : Container(),
                  // ),
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
                            _bloc.remove(data);
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
              onDragStarted: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              data: TextElement(
                bloc: _bloc,
                hint: 'Title',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
                unsetFocus: _unsetInputFocus,
                setFocus: _setInputFocus,
                id: _idGenerator,
                key: Key('${_tiles.length}-title'),
              ),
            ),
            Draggable<TextElement>(
              child: Icon(
                Icons.text_format,
                color: Colors.white,
                size: 50,
              ),
              feedback: Icon(
                Icons.text_format,
                color: Colors.white.withOpacity(0.5),
                size: 50,
              ),
              onDragStarted: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              data: TextElement(
                bloc: _bloc,
                hint: 'Paragraph',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
                unsetFocus: _unsetInputFocus,
                setFocus: _setInputFocus,
                id: _idGenerator,
                key: Key('${_idGenerator}-text'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextElementController {
  String id;
  TextEditingController controller;

  TextElementController({@required this.id, @required this.controller});
}
