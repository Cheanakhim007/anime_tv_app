
import 'package:anime_tv_app/bloc/get_genres_bloc.dart';
import 'package:anime_tv_app/bloc/get_movies_byGenre_bloc.dart';
import 'package:anime_tv_app/model/genre.dart';
import 'package:anime_tv_app/model/genre_response.dart';
import 'package:anime_tv_app/model/movie.dart';
import 'package:anime_tv_app/screen/genres_title_screen.dart';
import 'package:anime_tv_app/screen/search_screen.dart';
import 'package:anime_tv_app/widget/error_widget.dart';
import 'package:anime_tv_app/widget/loading_widget.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:anime_tv_app/style/theme.dart' as Style;


class GenresScreen extends StatefulWidget {

  @override
  _GenresScreenState createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen>{


  @override
  void initState() {
    super.initState();
    genresBloc..getGenres();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      appBar: AppBar(
        backgroundColor: Style.Colors.mainColor,
        centerTitle: true,
        elevation: 0.0,
        title: Text("GENRES MOVIE"),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                  ),
                );
              },
              icon: Icon(EvaIcons.searchOutline, color: Colors.white,)
          )
        ],
      ),
      body: SafeArea(
        child:  StreamBuilder<GenreResponse>(
          stream: genresBloc.subject.stream,
          builder: (context, AsyncSnapshot<GenreResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.error != null && snapshot.data.error.length > 0) {
                return BuildError.buildErrorWidget(snapshot.data.error);
              }
              return _buildGenresWidget(snapshot.data);
            } else if (snapshot.hasError) {
              return BuildError.buildErrorWidget(snapshot.data.error);
            } else {
              return Container(
                  height: 300,
                  child: Loading.buildLoadingWidget()
              );
            }
          },
        )
      ),
    );
  }

  Widget _buildGenresWidget(GenreResponse data) {
    List<Genre> genres = data.genres;
    print("===> ${genres.length}");
    if (genres.length == 0) {
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
      return GenresTitle(genres);
  }
}
