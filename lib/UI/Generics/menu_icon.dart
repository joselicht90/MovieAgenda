import 'package:flutter/material.dart';

class MenuIcon extends StatelessWidget {
  const MenuIcon({
    Key key,
    @required double iconsOpacity,
    @required Widget icon,
    @required Alignment alignment,
    Function(BuildContext) callback,
  })  : _iconsOpacity = iconsOpacity,
        _alignment = alignment,
        _icon = icon,
        _callback = callback,
        super(key: key);

  final double _iconsOpacity;
  final Widget _icon;
  final Alignment _alignment;
  final Function(BuildContext) _callback;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 300),
      opacity: _iconsOpacity,
      child: AnimatedContainer(
        alignment: _alignment,
        duration: Duration(milliseconds: 300),
        child: InkWell(
          customBorder: CircleBorder(),
          onTap: () {
            if(_callback != null)
              return _callback(context);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: _icon,
          ),
        ),
      ),
    );
  }
}