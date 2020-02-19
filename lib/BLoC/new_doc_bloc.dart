import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:movie_agenda/BLoC/interface/bloc.dart';

//BLOC DE PRODUCTO
class NewDocumentBloc implements Bloc {
  List<TextStyle> _styles = List<TextStyle>();
  final _controllerDocumento = StreamController<List<TextStyle>>();

  List<StreamController<TextStyle>> _controllers =
      List<StreamController<TextStyle>>();

  //List<Stream<TextStyle>> streams = List<Stream<TextStyle>>();

  Stream<List<TextStyle>> get streamStyles => _controllerDocumento.stream;

  Stream<TextStyle> getStream(int index) {
    return _controllers[index].stream;
  }

  void addStyle(TextStyle style) {
    _styles.add(style);
  }

  void addController(TextStyle style){
    addStyle(style);
    _controllers.add(StreamController<TextStyle>.broadcast());
    _controllers.last.sink.add(style);
  }

  void updateStyle(TextStyle newStyle, int idOld) {
    _styles[idOld] = newStyle;
    _controllerDocumento.sink.add(_styles);
  }

  void getStyles() {
    for (StreamController c in _controllers) {
      c.sink.add(_styles[_controllers.indexOf(c)]);
    }
  }

  @override
  void dispose() {
    _controllerDocumento.close();
  }
}
