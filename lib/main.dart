import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_agenda/UI/Home/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => ThemeData(
        brightness: brightness,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        canvasColor: brightness == Brightness.light ? Color(0xFFdfdfdf) : Color(0xFF313131),
        accentColor: brightness == Brightness.light ? Colors.blue : Color(0xFFec625f),
      ),
      themedWidgetBuilder: (context, theme) {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            theme.brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light));
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: theme,
          home: HomePage(),
        );
      },
    );
  }
}