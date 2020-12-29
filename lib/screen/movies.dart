import 'package:anime_tv_app/bloc/get_movies_bloc.dart';
import 'package:anime_tv_app/model/movie.dart';
import 'package:anime_tv_app/model/movie_repository.dart';
import 'package:anime_tv_app/widget/error_widget.dart';
import 'package:anime_tv_app/widget/loading_widget.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:anime_tv_app/style/theme.dart' as Style;

class MoviesScreen extends StatefulWidget {
  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {

  @override
  void initState() {
    super.initState();
    moviesBloc..getMovies();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
         appBar: AppBar(
        backgroundColor: Style.Colors.mainColor,
        centerTitle: true,
        elevation: 0.0,
        // leading: Icon(EvaIcons.menu2Outline, color: Colors.white,),
        title: Text("Movies List"),
      ),
      body: SafeArea(
        child: StreamBuilder<MovieResponse>(
          stream: moviesBloc.subject.stream,
          builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null && snapshot.data.error.length > 0) {
                return BuildError.buildErrorWidget(snapshot.data.error);
              }
              return _buildMoviesWidget(snapshot.data);
            } else if (snapshot.hasError) {
              return BuildError.buildErrorWidget(snapshot.error);
            } else {
              return Container(
                height: double.infinity,
                  child: Loading.buildLoadingWidget()
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildMoviesWidget(MovieResponse data) {
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
    } else{
      final orientation = MediaQuery.of(context).orientation;
      return GridView.builder(
        scrollDirection: Axis.vertical,
        itemCount: movies.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (orientation == Orientation.portrait) ? 3 : 4,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 1),),

        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(10),
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
                      height: 170.0,
                      decoration: new BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(4.0)),
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
                      textAlign: TextAlign.center,
                      style: TextStyle(
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
      );
    }
  }
}
