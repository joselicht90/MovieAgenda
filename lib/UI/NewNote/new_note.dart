import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:movie_agenda/BLoC/interface/bloc_provider.dart';
import 'package:movie_agenda/BLoC/new_note_bloc.dart';
import 'package:movie_agenda/UI/Notes/text_element.dart';
import 'package:reorderables/reorderables.dart';

class NewNote extends StatefulWidget {
  @override
  _NewNoteState createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> with WidgetsBindingObserver {
  Color _dragColor = Colors.transparent;
  bool _isDragging = false;
  Color floatColor = Color(0xFFec625f);
  var _isKeyboardOpen = false;
  TextStyle _defaultTitleStyle =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30);

  TextStyle _defaultParagraphStyle =
      TextStyle(color: Colors.white, fontSize: 18);

  NewNoteBloc _bloc = NewNoteBloc();

  @override
  void initState() {
    super.initState();
    _bloc.getElements();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final value = MediaQuery.of(context).viewInsets.bottom;
    if (value > 0) {
      if (_isKeyboardOpen) {
        _unsetInputFocus();
      }
      _isKeyboardOpen = false;
    } else {
      _isKeyboardOpen = true;
    }
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
      body: Stack(
        children: <Widget>[
          BlocProvider(
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
                  buildNoteBody(_onReorder),
                ],
              ),
            ),
          ),
          buildFloatingButton(),
          _isKeyboardOpen
              ? StyleSwitcher(
                  bloc: _bloc,
                )
              : Container(),
        ],
      ),
    );
  }

  AnimatedSwitcher buildFloatingButton() {
    Widget child;
    if (_isKeyboardOpen)
      child = Container();
    else if (_isDragging)
      child = Align(
        alignment: Alignment.bottomRight,
        child: DragTarget<int>(
          builder: (context, x, y) {
            return Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Theme.of(context).accentColor),
              child: Icon(
                Icons.delete,
                size: 35,
              ),
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
        ),
      );
    else
      child = Align(
        alignment: Alignment.bottomRight,
        child: AddButton(
          setFocus: _setInputFocus,
          unsetFocus: _unsetInputFocus,
          bloc: _bloc,
        ),
      );
    return AnimatedSwitcher(
        duration: Duration(milliseconds: 300), child: child);
  }

  Expanded buildNoteBody(void _onReorder(int oldIndex, int newIndex)) {
    return Expanded(
      child: Container(
        width: double.infinity,
        color: _dragColor,
        child: StreamBuilder<Object>(
          stream: _bloc.streamElements,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> elements = snapshot.data;
              return Container(
                child: buildDragTargetNoteBody(
                    elements.map<Widget>((e) => e).toList(), _onReorder),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  DragTarget buildDragTargetNoteBody(
      List<Widget> elements, void _onReorder(int oldIndex, int newIndex)) {
    return DragTarget<dynamic>(
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
    );
  }
}

class StyleSwitcher extends StatelessWidget {
  const StyleSwitcher({
    @required this.bloc,
    Key key,
  }) : super(key: key);

  final NewNoteBloc bloc;

  @override
  Widget build(BuildContext context) {
    TextStyle style = bloc.currentElement.style;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        child: Row(
          children: <Widget>[
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.format_bold)),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.format_italic)),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                style.fontFamily ??
                    Theme.of(context).textTheme.bodyText1.fontFamily,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddButton extends StatefulWidget {
  const AddButton({
    @required NewNoteBloc bloc,
    @required Function(dynamic) setFocus,
    @required Function unsetFocus,
    Key key,
  })  : _bloc = bloc,
        _setFocus = setFocus,
        _unsetFocus = unsetFocus,
        super(key: key);
  final Function(dynamic) _setFocus;
  final Function _unsetFocus;
  final NewNoteBloc _bloc;

  @override
  _AddButtonState createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  void collapse() {
    setState(() {
      _addCollapsed = true;
    });
  }

  void expand() {
    setState(() {
      _addCollapsed = false;
    });
  }

  bool _addCollapsed = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: const EdgeInsets.all(15),
      duration: Duration(milliseconds: 300),
      width: _addCollapsed
          ? MediaQuery.of(context).size.width * 0.2
          : MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(50)),
      child: Row(
          mainAxisSize: MainAxisSize.max,
          children:
              _addCollapsed ? getCollapsedChildren() : getExpandedChildren()),
    );
  }

  List<Widget> getCollapsedChildren() {
    return [
      Expanded(
        child: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => expand(),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              margin: const EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add),
                  Text(
                    'Add',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    ];
  }

  List<Widget> getExpandedChildren() {
    DocElement title = TitleElement(
      key: Key('title'),
      bloc: widget._bloc,
      hint: 'Title',
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
      unsetFocus: widget._unsetFocus,
      setFocus: widget._setFocus,
      id: widget._bloc.getId(),
    );
    DocElement paragraph = ParagraphElement(
      key: Key('paragraph'),
      bloc: widget._bloc,
      hint: 'Paragraph',
      style: TextStyle(color: Colors.white, fontSize: 18),
      unsetFocus: widget._unsetFocus,
      setFocus: widget._setFocus,
      id: widget._bloc.getId(),
    );
    return [
      ElementOption(
        icon: Icon(Icons.title),
        collapse: collapse,
        docElement: title,
      ),
      ElementOption(
        icon: Icon(Icons.short_text),
        collapse: collapse,
        docElement: paragraph,
      ),
      Expanded(
        child: Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => collapse(),
            child: Container(
                margin: const EdgeInsets.all(5), child: Icon(Icons.close)),
          ),
        ),
      )
    ];
  }
}

class ElementOption extends StatelessWidget {
  const ElementOption({
    Key key,
    @required collapse,
    @required icon,
    @required docElement,
  })  : _collapse = collapse,
        _icon = icon,
        _docElement = docElement,
        super(key: key);

  final Icon _icon;
  final DocElement _docElement;
  final Function _collapse;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Draggable<dynamic>(
        child: _icon,
        feedback: Icon(
          _icon.icon,
          color: Colors.white.withOpacity(0.4),
        ),
        onDragStarted: () {
          _collapse();
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        data: _docElement,
      ),
    );
  }
}
