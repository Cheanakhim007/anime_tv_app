import 'package:anime_tv_app/bloc/get_movie_home_bloc.dart';
import 'package:anime_tv_app/model/home_repository.dart';
import 'package:anime_tv_app/model/movie.dart';
import 'package:anime_tv_app/screen/search_screen.dart';
import 'package:anime_tv_app/widget/error_widget.dart';
import 'package:anime_tv_app/widget/header.dart';
import 'package:anime_tv_app/widget/loading_widget.dart';
import 'package:anime_tv_app/widget/popular.dart';
import 'package:anime_tv_app/widget/recent.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:anime_tv_app/style/theme.dart' as Style;


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    moviesSearchBloc..getMoviesHome();
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
        title: Text("ANIME MOVIE"),
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
      body: StreamBuilder<HomeResponse>(
        stream: moviesSearchBloc.subject.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.error != null && snapshot.data.error.length > 0) {
              return BuildError.buildErrorWidget(snapshot.data.error);
            }
            List<Movie>  newS = snapshot.data.newSeason;
            print("-------> ${newS}");
            return  ListView(
              children: <Widget>[
                Header(),
                PopularMovie(),
                RecentMovie(),
              ],
            );
          } else if (snapshot.hasError) {
            return BuildError.buildErrorWidget(snapshot.error);
          } else {
            return Container(
                height: double.infinity,
                child: Loading.buildLoadingWidget()
            );
          }
        }
      ),
    );
  }
}