import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:movie_agenda/BLoC/detail_bloc.dart';
import 'package:movie_agenda/DataLayer/models/MovieCredits.dart';

class ActorContainer extends StatelessWidget {
  const ActorContainer({
    Key key,
    @required this.actor,
    @required this.bloc,
  }) : super(key: key);

  final DetailBloc bloc;
  final Cast actor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(10),
            height: 150,
            width: 100,
            decoration: BoxDecoration(
              color:
                  DynamicTheme.of(context).brightness ==
                          Brightness.light
                      ? Color(0xFFf0f0f0)
                      : Color(0xFF303030),
              borderRadius: BorderRadius.circular(7),
              boxShadow: [
                BoxShadow(
                    offset: Offset(4, 4),
                    color: Colors.black26,
                    blurRadius: 6,
                    spreadRadius: 0.5),
              ],
            ),
            child: actor.profilePath != null
                ? ClipRRect(
                    borderRadius:
                        BorderRadius.circular(7),
                    child: bloc.getPersonImage(
                      actor.profilePath,
                    ),
                  )
                : Icon(
                    Icons.person,
                    size: 50,
                  )),
        Text(
          actor.name,
          style: TextStyle(
              color: Theme.of(context).accentColor, fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

