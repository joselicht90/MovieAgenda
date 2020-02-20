import 'dart:ui';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:movie_agenda/BLoC/interface/bloc_provider.dart';
import 'package:movie_agenda/BLoC/new_doc_bloc.dart';
import 'package:movie_agenda/UI/Notes/text_element.dart';
import 'package:reorderables/reorderables.dart';

class NotesHome extends StatefulWidget {
  @override
  _NotesHomeState createState() => _NotesHomeState();
}

class _NotesHomeState extends State<NotesHome> {
  List<dynamic> _tiles = [];
  Color _dragColor = Colors.transparent;
  bool _isDragging = false;
  Color floatColor = Color(0xFFec625f);
  dynamic _currentElement;
  int _idGenerator = 0;

  NewDocumentBloc _bloc = NewDocumentBloc();

  @override
  void initState() {
    super.initState();
    _bloc.getElements();
  }

  _setInputFocus(dynamic element) {
    _bloc.setInputFocus(element);
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
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: _dragColor,
                  child: StreamBuilder<Object>(
                      stream: _bloc.streamElements,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<dynamic> e = snapshot.data;
                          List<Widget> elements = e.map<Widget>((e) => e).toList();
                          return Container(
                            child: DragTarget<dynamic>(
                              builder: (context, candidateData, rejectedData) {
                                return SingleChildScrollView(
                                  child: ReorderableWrap(
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
                                      setState(() {
                                        _isDragging = false;
                                      });

                                      //floatColor = Color(0xFFec625f);
                                    },
                                  ),
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
                                _bloc.addElement(data);
                                setState(() {
                                  _dragColor = Colors.transparent;
                                });
                              },
                            ),
                          );
                        }
                        return Container();
                      }),
                ),
              ),
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
            Draggable<dynamic>(
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
              data: TitleElement(
                key: Key('title'),
                bloc: _bloc,
                hint: 'Title',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
                unsetFocus: _unsetInputFocus,
                setFocus: _setInputFocus,
                id: _bloc.getId(),
              ),
            ),
            Draggable<dynamic>(
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
              data: ParagraphElement(
                key: Key('paragraph'),
                bloc: _bloc,
                hint: 'Paragraph',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
                unsetFocus: _unsetInputFocus,
                setFocus: _setInputFocus,
                id: _bloc.getId(),
              ),
            ),
            Draggable<dynamic>(
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
              data: DragTargetRow(id: _bloc.getId(),bloc: _bloc,key: Key('row'),),
            ),
          ],
        ),
      ),
    );
  }
}
