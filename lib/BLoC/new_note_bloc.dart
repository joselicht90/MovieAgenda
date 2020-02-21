import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:movie_agenda/BLoC/interface/bloc.dart';
import 'package:movie_agenda/UI/Notes/text_element.dart';

//BLOC DE PRODUCTO
class NewNoteBloc implements Bloc {
  List<TextStyle> _styles = List<TextStyle>();
  int _indexGenerator = -1;

  List<dynamic> elements = List<dynamic>();

  dynamic currentElement;

  final _controllerDocumento = StreamController<List<dynamic>>();

  List<StreamController<TextStyle>> _controllers =
      List<StreamController<TextStyle>>();

  List<Stream<TextStyle>> streams = List<Stream<TextStyle>>();

  Stream<List<dynamic>> get streamElements => _controllerDocumento.stream;

  Stream<TextStyle> getStream(int index) {
    return _controllers[index].stream;
  }

  int getId() {
    _indexGenerator++;
    return _indexGenerator;
  }

  void addStyle(TextStyle style) {
    _styles.add(style);
  }

  void addElement(dynamic element) {
    elements.add(element);
    currentElement = elements.last;
    _controllerDocumento.sink.add(elements);
  }

  void reorder(int oldIndex, int newIndex) {
    dynamic tile = elements.removeAt(oldIndex);
    elements.insert(newIndex, tile);
    _controllerDocumento.sink.add(elements);
  }

  void addController(TextStyle style) {
    addStyle(style);
    _controllers.add(StreamController<TextStyle>());
    _controllers.last.sink.add(style);
  }

  void updateStyle(TextStyle newStyle) {
    int i = elements.indexOf(currentElement);
    if (i > -1 && currentElement.children == null) {
      elements.removeAt(i);
      currentElement.setStyle(newStyle);
      elements.insert(i, currentElement);
      currentElement.counter.value++;
    }
    else{
      List<dynamic> e = elements.singleWhere((element) => element.children != null && element.children.any((x) => x.child.id == currentElement.id)).children;
      int i = e.indexWhere((x)=> x.child.id == currentElement.id);
      e.removeWhere((x) => x.child.id == currentElement.id);
      currentElement.setStyle(newStyle);
      e.insert(i, Expanded(child: currentElement,));
      currentElement.counter.value++;
    }
    _controllerDocumento.sink.add(elements);
  }

  void remove(int index) {
    elements.removeAt(index);
    _controllerDocumento.sink.add(elements);
  }

  void getElements() {
    _controllerDocumento.sink.add(elements);
  }

  void getStyles() {
    for (StreamController c in _controllers) {
      c.sink.add(_styles[_controllers.indexOf(c)]);
    }
  }

  setInputFocus(dynamic element) {
    currentElement = element;
    _controllerDocumento.sink.add(elements);
  }

  unsetInputFocus() {
    currentElement = null;
    _controllerDocumento.sink.add(elements);
  }

  @override
  void dispose() {
    for (StreamController sc in _controllers) {
      sc.close();
    }
    _controllerDocumento.close();
    _indexGenerator = -1;
  }
}
