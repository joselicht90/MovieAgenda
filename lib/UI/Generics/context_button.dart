import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:movie_agenda/UI/Generics/menu_icon.dart';
import 'package:movie_agenda/UI/Notes/notes.dart';

class ContextButton extends StatefulWidget {
  const ContextButton({
    Key key,
  }) : super(key: key);

  @override
  _ContextButtonState createState() => _ContextButtonState();
}

class _ContextButtonState extends State<ContextButton> {

  void _changeTheme(BuildContext context) {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }

  double _buttonSize = 50;
  double _radius = 200;
  bool _isOpen = false;
  double _iconsOpacity = 0;
  Alignment _homeAlignment = Alignment(1, 1);
  Alignment _personAlignment = Alignment(1, 1);
  Alignment _darkModeAlignment = Alignment(1, 1);

  void _onTap() {
    setState(() {
      if (!_isOpen) {
        _buttonSize = 150;
        _homeAlignment = Alignment(-0.9, 1);
        _personAlignment = Alignment(-0.7, 0.2);
        _darkModeAlignment = Alignment(-0.1, -0.5);
        _iconsOpacity = 1;
      } else {
        _buttonSize = 50;
        _homeAlignment = Alignment(1, 1);
        _personAlignment = Alignment(1, 1);
        _darkModeAlignment = Alignment(1, 1);
        _iconsOpacity = 0;
      }
      _isOpen = !_isOpen;
    });
  }

  navigateToNotes(BuildContext context){
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotesHome()));
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: _buttonSize,
        width: _buttonSize,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(_radius),
          ),
        ),
        child: Stack(
          children: <Widget>[
            MenuIcon(
              iconsOpacity: _iconsOpacity,
              alignment: _homeAlignment,
              icon: Icon(Icons.home),
            ),
            MenuIcon(
              iconsOpacity: _iconsOpacity,
              alignment: _personAlignment,
              icon: Icon(Icons.person),
              callback: navigateToNotes,
            ),
            MenuIcon(
              iconsOpacity: _iconsOpacity,
              alignment: _darkModeAlignment,
              icon: ImageIcon(
                AssetImage('assets/icons/dark_mode.png'),
                color: Theme.of(context).iconTheme.color,
              ),
              callback: _changeTheme,
            ),
            GestureDetector(
              onTap: () => _onTap(),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  //color: Theme.of(context).accentColor,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Icon(
                    Icons.menu,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

