import 'package:anime_tv_app/bloc/get_popular_movies_bloc.dart';
import 'package:anime_tv_app/model/movie.dart';
import 'package:anime_tv_app/model/movie_repository.dart';
import 'package:anime_tv_app/screen/movies.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:anime_tv_app/style/theme.dart' as Style;
import 'package:flutter/widgets.dart';

import 'error_widget.dart';
import 'loading_widget.dart';

class PopularMovie extends StatefulWidget {
  final List<Movie> movie;
  final String label;
  PopularMovie({this.movie, this.label});
  @override
  _PopularMovieState createState() => _PopularMovieState();
}

class _PopularMovieState extends State<PopularMovie> {

  @override
  void initState() {
    super.initState();
    // moviesPopularBloc..getMoviesPopular();
  }
  @override
  Widget build(BuildContext context) {
    return _buildPopularWidget(widget.movie);
  /*  return StreamBuilder<MovieResponse>(
      stream: moviesPopularBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return BuildError.buildErrorWidget(snapshot.data.error);
          }
          return _buildPopularWidget(snapshot.data);
        } else if (snapshot.hasError) {
          return BuildError.buildErrorWidget(snapshot.error);
        } else {
          return Loading.buildLoadingWidget();
        }
      },
    );*/
  }

  Widget _buildPopularWidget( List<Movie> movies) {
    if (movies.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  "No More Movies",
                  style: TextStyle(color: Colors.black45),
                )
              ],
            )
          ],
        ),
      );
    } else
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 20.0),
                  child: Text(widget.label, style: TextStyle(
                      color: Style.Colors.background,
                      fontWeight: FontWeight.w800,
                      fontSize: 14.0
                  ),),
                ),
                
                Container(
                  child: IconButton(
                    padding: EdgeInsets.only(top: 20.0),
                      icon: Icon(Icons.widgets_outlined, color: Style.Colors.background,),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MoviesScreen(status: widget.label)),
                        );
                      }
                      ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            height: 245.0,
            padding: EdgeInsets.only(left: 10.0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                      top: 10.0,
                      bottom: 10.0,
                      right: 15.0
                  ),
                  child: GestureDetector(
                    onTap: () {

                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        movies[index].image == null ?
                        Container(
                          width: 120.0,
                          height: 180.0,
                          decoration: new BoxDecoration(
                            color: Style.Colors.secondColor,
                            borderRadius:
                            BorderRadius.all(Radius.circular(2.0)),
                            shape: BoxShape.rectangle,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(EvaIcons.filmOutline, color: Colors.white, size: 60.0,)
                            ],
                          ),
                        ):
                        Container(
                            width: 120.0,
                            height: 180.0,
                            decoration: new BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(2.0)),
                              shape: BoxShape.rectangle,
                              image: new DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(movies[index].image)),
                            )),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          width: 100,
                          child: Text(
                            movies[index].title,
                            maxLines: 2,
                            style: TextStyle(
                                height: 1.4,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
  }
}
