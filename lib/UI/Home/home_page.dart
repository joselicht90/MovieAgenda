import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:movie_agenda/BLoC/home_bloc.dart';
import 'package:movie_agenda/BLoC/interface/bloc_provider.dart';
import 'package:movie_agenda/UI/Generics/context_button.dart';
import 'package:movie_agenda/UI/Home/home_body.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  final HomeBloc _bloc = HomeBloc();

  @override
  Widget build(BuildContext context) {
    Color _tileTextColor =
        DynamicTheme.of(context).brightness == Brightness.light
            ? Color(0xFF414141)
            : Color(0x70f9f6f7);
    _bloc.getUpcomingMoviesResult();
    return BlocProvider(
      bloc: _bloc,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              HomeBody(bloc: _bloc, tileTextColor: _tileTextColor),
              ContextButton(),
            ],
          ),
        ),
      ),
    );
  }
}






