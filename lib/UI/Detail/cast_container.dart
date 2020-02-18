import 'package:flutter/material.dart';
import 'package:movie_agenda/BLoC/detail_bloc.dart';
import 'package:movie_agenda/DataLayer/models/MovieCredits.dart';
import 'package:movie_agenda/UI/Detail/actor_container.dart';

class CastContainer extends StatelessWidget {
  const CastContainer({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  final DetailBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Cast', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.grey.shade200),),
        Container(
          height: 200,
          child: StreamBuilder<MovieCredits>(
            stream: bloc.streamMovieCredits,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                MovieCredits credits = snapshot.data;
                List<Cast> cast = credits.cast;
                return Container(
                  height: 150,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: cast.length,
                    itemBuilder: (context, index) => ActorContainer(actor: cast[index], bloc: bloc,),
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ],
    );
  }
}