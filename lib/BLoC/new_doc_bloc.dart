import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:movie_agenda/BLoC/interface/bloc.dart';
import 'package:movie_agenda/UI/notes/text_element.dart';

//BLOC DE PRODUCTO
class NewDocumentBloc implements Bloc {
  List<TextStyle> _styles = List<TextStyle>();

  List<TextElement> elements = List<TextElement>();

  TextElement currentElement;

  final _controllerDocumento = StreamController<List<TextElement>>();

  List<StreamController<TextStyle>> _controllers =
      List<StreamController<TextStyle>>();

  List<Stream<TextStyle>> streams = List<Stream<TextStyle>>();

  Stream<List<TextElement>> get streamElements => _controllerDocumento.stream;

  Stream<TextStyle> getStream(int index) {
    return _controllers[index].stream;
  }

  void addStyle(TextStyle style) {
    _styles.add(style);
  }

  void addElement(TextElement element) {
    elements.add(element);
    currentElement = elements.last;
    _controllerDocumento.sink.add(elements);
  }

  void reorder(int oldIndex, int newIndex) {
    TextElement tile = elements.removeAt(oldIndex);
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
    elements.removeAt(i);
    currentElement.style = newStyle;
    elements.insert(i, currentElement);
    currentElement.counter.value++;
    _controllerDocumento.sink.add(elements);
  }

  void remove(int id){
    elements.removeWhere((element) => element.id == id);
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

  setInputFocus(int id) {
      currentElement = elements.singleWhere((element) => element.id == id);
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
  }
}
