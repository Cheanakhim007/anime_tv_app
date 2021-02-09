import 'package:anime_tv_app/bloc/get_movies_byGenre_bloc.dart';
import 'package:anime_tv_app/model/movie.dart';
import 'package:anime_tv_app/model/movie_repository.dart';
import 'package:anime_tv_app/screen/movie_detail_screen.dart';
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
  List<Movie> _movies;
  ScrollController _scrollController;
  bool _stopRequest = false;
  bool _isLoading = false;
  int _countPage = 1;

  @override
  void initState() {
    super.initState();
    _movies = [];
    _stopRequest = false;
    _isLoading = false;
    _scrollController = new ScrollController();
    _scrollController.addListener(_scrollListener);
    print("====> id ${genreId}");
    moviesByGenreBloc..getMoviesByGenre(genreId, countPage: _countPage);
  }

  @override
  void dispose() {
    moviesByGenreBloc..dispose();
    super.dispose();
  }
  void _scrollListener() async {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;
    double delta = 700;
    if ( maxScroll - currentScroll <= delta && maxScroll > 0) {
      if (!_isLoading && !_stopRequest) {
        _countPage += 1;
        setState(() {
          _isLoading = true;
        });
        moviesByGenreBloc..getMoviesByGenre(genreId, countPage: _countPage);
        Future.delayed(Duration(seconds: 2)).then((value) {
          _isLoading = false;
          setState(() {});
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MovieResponse>(
    stream: moviesByGenreBloc.subject.stream,
    builder: (context, AsyncSnapshot<MovieResponse> snapshot) {
      print("===> ${snapshot}");
      if (snapshot.hasData) {
        if (snapshot.data.error != null && snapshot.data.error.length > 0 && _countPage == 1) {
          return BuildError.buildErrorWidget(snapshot.data.error);
        }
        return _buildHomeWidget(snapshot.data);
      } else if (snapshot.hasError && _countPage == 1) {
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
  Widget _buildHomeWidget(MovieResponse data) {
    if(data.movies.length == 0)
       _stopRequest = true;
    _movies.addAll(data.movies);
    // remove duplicates movies
    _movies = [...{..._movies}];
    print("----> ${_movies.length}");
    if (_movies.length == 0) {
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
      return Column(
        children: [
          Expanded(
            child: GridView.builder(
              scrollDirection: Axis.vertical,
              itemCount: _movies.length + 1,
              controller: _scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: (orientation == Orientation.portrait) ? 3 : 4,
                  childAspectRatio: (orientation == Orientation.portrait)
                      ? MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1)
                      : MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 0.4)),
              itemBuilder: (context, index) {
                if(index == _movies.length)
                  return _isLoading ? Padding(
                    padding: const EdgeInsets.all(6),
                    child: Loading.buildLoadingWidget(),
                  ) : Container();
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MovieDetail(movie:  _movies[index], label: "gendres")),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _movies[index].image == null ?
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
                        Hero(
                          tag: _movies[index].id + "gendres",
                          child: Container(
                              width: 120.0,
                              height: 170.0,
                              decoration: new BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                shape: BoxShape.rectangle,
                                image: new DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(_movies[index].image)),
                              )),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Expanded(
                          child: Container(
                            width: 100,
                            child: Text(
                              _movies[index].title,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.0),
                            ),
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
}
