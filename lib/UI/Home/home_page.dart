import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  void _changeTheme(BuildContext context) {
    DynamicTheme.of(context).setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          Center(
            child: Container(
              child: FlatButton(
                onPressed: () => _changeTheme(context),
                child: Text('Change Theme'),
              ),
            ),
          ),
          ContextButton()
        ],
      ),
    );
  }
}

class ContextButton extends StatefulWidget {
  const ContextButton({
    Key key,
  }) : super(key: key);

  @override
  _ContextButtonState createState() => _ContextButtonState();
}

class _ContextButtonState extends State<ContextButton> {
  double _buttonSize = 50;
  double _radius = 200;
  bool _isOpen = false;
  double _iconsOpacity = 0;
  Alignment _homeAlignment = Alignment(1, 1);
  Alignment _personAlignment = Alignment(1, 1);

  void _onTap() {
    setState(() {
      if (_isOpen) {
        _buttonSize = 150;
        _homeAlignment = Alignment(-0.9, 1);
        _personAlignment = Alignment(-0.7, 0.2);
        _iconsOpacity = 1;
      } else {
        _buttonSize = 50;
        _homeAlignment = Alignment(1, 1);
        _personAlignment = Alignment(1, 1);
        _iconsOpacity = 0;
      }
      _isOpen = !_isOpen;
    });
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
            AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: _iconsOpacity,
              child: AnimatedContainer(
                alignment: _homeAlignment,
                duration: Duration(milliseconds: 300),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Icon(Icons.home),
                ),
              ),
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 300),
              opacity: _iconsOpacity,
              child: AnimatedContainer(
                alignment: _personAlignment,
                duration: Duration(milliseconds: 300),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: Icon(Icons.person),
                ),
              ),
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
