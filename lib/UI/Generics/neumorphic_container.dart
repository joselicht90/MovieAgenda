import 'package:flutter/material.dart';

class NumorphismContainer extends StatefulWidget {
  const NumorphismContainer({
    Key key,
  }) : super(key: key);


  @override
  _NumorphismContainerState createState() => _NumorphismContainerState();
}

class _NumorphismContainerState extends State<NumorphismContainer> {
  static var selectedBoxShadows = [
    BoxShadow(
        color: Colors.black.withOpacity(0.8),
        offset: Offset(10, 10),
        blurRadius: 7,
        spreadRadius: 1),
    BoxShadow(
        color: Colors.white.withOpacity(0.1),
        offset: Offset(-2, -1),
        blurRadius: 1,
        spreadRadius: -0.075),
  ];

  static var nonSelectedBoxShadows = [
    BoxShadow(
        color: Colors.black.withOpacity(0.5),
        offset: Offset(-1, -1),
        blurRadius: 2,
        spreadRadius: -1),
    BoxShadow(
        color: Colors.white.withOpacity(0.1),
        offset: Offset(1, 1),
        blurRadius: 1,
        spreadRadius: -1),
  ];

  static var selectedGradient = LinearGradient(
    colors: [
      Color(0xFF303135),
      Color(0xFF060709),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static var nonSelectedGradient = RadialGradient(
    colors: [Color(0xFF000000).withOpacity(0.8), Colors.transparent],
    radius: 5,
  );

  List<BoxShadow> containerShadow = selectedBoxShadows;
  Gradient containerGradient = nonSelectedGradient;
  var selected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selected) {
            containerGradient = nonSelectedGradient;
            containerShadow = nonSelectedBoxShadows;
          } else {
            containerGradient = selectedGradient;
            containerShadow = selectedBoxShadows;
          }
          selected = !selected;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        //padding: const EdgeInsets.all(1),
        height: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: containerShadow),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: containerGradient,
            //color: Color(0xFF000000).withOpacity(0.8)
          ),
          child: Center(
            child: Icon(
              Icons.bluetooth,
              color: !selected ? Colors.grey : Colors.white,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}