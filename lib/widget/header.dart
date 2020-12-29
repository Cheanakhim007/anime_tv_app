import 'package:anime_tv_app/bloc/get_movies_new_season_bloc.dart';
import 'package:anime_tv_app/model/movie.dart';
import 'package:anime_tv_app/model/movie_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:anime_tv_app/style/theme.dart' as Style;
import 'package:page_indicator/page_indicator.dart';

import 'error_widget.dart';
import 'loading_widget.dart';

class Header extends StatefulWidget {
  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {

  PageController pageController = PageController(viewportFraction: 1, keepPage: true);

  @override
  void initState() {
    super.initState();
    moviesNewSeasonBloc..getMovies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
      stream: moviesNewSeasonBloc.subject.stream,
      builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.length > 0) {
            return BuildError.buildErrorWidget(snapshot.data.error);
          }
          return _buildHomeWidget(snapshot.data);
        } else if (snapshot.hasError) {
          return BuildError.buildErrorWidget(snapshot.error);
        } else {
          return Container(
            height: 220,
              child: Loading.buildLoadingWidget()
          );
        }
      },
    );
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
        height: 220.0,
        child: PageIndicatorContainer(
          align: IndicatorAlign.bottom,
          length: movies.take(10).length,
          indicatorSpace: 8.0,
          padding: const EdgeInsets.all(5.0),
          indicatorColor: Style.Colors.titleColor,
          indicatorSelectorColor: Style.Colors.secondColor,
          shape: IndicatorShape.circle(size: 5.0),
          child: PageView.builder(
            controller: pageController,
            scrollDirection: Axis.horizontal,
            itemCount: movies.take(5).length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {

                },
                child: Stack(
                  children: <Widget>[
                    Hero(
                      tag: movies[index].id,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 220.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: new DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage( movies[index].image)),
                          )),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      decoration: BoxDecoration(

                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: [
                              0.0,
                              0.9
                            ],
                            colors: [
                              Style.Colors.mainColor.withOpacity(1.0),
                              Style.Colors.mainColor.withOpacity(0.0)
                            ]),
                      ),
                    ),
                    Positioned(
                        bottom: 0.0,
                        top: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Icon(FontAwesomeIcons.playCircle, color: Style.Colors.secondColor, size: 40.0,)
                    ),
                    Positioned(
                        bottom: 30.0,
                        child: Container(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          width: 250.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                movies[index].title,
                                style: TextStyle(
                                    height: 1.5,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                            ],
                          ),
                        )
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
  }
}
