import 'package:anime_tv_app/bloc/get_movies_byGenre_bloc.dart';
import 'package:anime_tv_app/model/movie.dart';
import 'package:anime_tv_app/model/movie_repository.dart';
import 'package:anime_tv_app/widget/error_widget.dart';
import 'package:anime_tv_app/widget/loading_widget.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:anime_tv_app/style/theme.dart' as Style;

class GenreMovies extends StatefulWidget {
  final String genreId;
  GenreMovies({Key key, @required this.genreId})
      : super(key: key);
  @override
  _GenreMoviesState createState() => _GenreMoviesState(genreId);
}

class _GenreMoviesState extends State<GenreMovies> {
  final String genreId;
  _GenreMoviesState(this.genreId);
  @override
  void initState() {
    super.initState();
    moviesByGenreBloc..getMoviesByGenre(genreId);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
    stream: moviesByGenreBloc.subject.stream,
    builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data.error != null && snapshot.data.error.length > 0) {
          return BuildError.buildErrorWidget(snapshot.data.error);
        }
        return _buildHomeWidget(snapshot.data);
      } else if (snapshot.hasError) {
        return BuildError.buildErrorWidget(snapshot.data.error);
      } else {
        return Container(
            height: double.infinity,
            child: Loading.buildLoadingWidget()
        );
      }
    },
      );
  }

  Widget _buildLoadingWidget() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 25.0,
          width: 25.0,
          child: CircularProgressIndicator(
            valueColor:
                new AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 4.0,
          ),
        )
      ],
    ));
  }

  Widget _buildErrorWidget(String error) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Error occured: $error"),
      ],
    ));
  }

  Widget _buildHomeWidget(MovieResponse data) {
    List<Movie> movies = data.movies;
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
      return Container(
        height: 270.0,
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
                 /* Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MovieDetail(movie:  _movies[index], label: widget.status)),
                  );*/
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
      );
  }
}
