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
  List<Movie> _movies;
  ScrollController _scrollController;
  int _countPage = 1;
  bool _stopRequest = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _movies = [];
    _stopRequest = false;
    _isLoading = false;
    _scrollController = new ScrollController();
    _scrollController.addListener(_scrollListener);
    moviesBloc..getMovies(countPage: _countPage);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _scrollListener() async {
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;
    double delta = 700;
    if ( maxScroll - currentScroll <= delta && maxScroll > 0) {
        if (!_isLoading && !_stopRequest) {
          _countPage += 1;
          _isLoading = true;
          moviesBloc..getMovies(countPage: _countPage);
          Future.delayed(Duration(milliseconds: 10)).then((value) {
              _isLoading = false;
            setState(() {});
         });
        }
    }
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
              if (snapshot.data.error != null && snapshot.data.error.length > 0 && snapshot.hasError && _countPage == 1) {
                return BuildError.buildErrorWidget(snapshot.data.error);
              }
              return _buildMoviesWidget(snapshot.data);
            } else if (snapshot.hasError && _countPage == 1) {
              return BuildError.buildErrorWidget(snapshot.error);
            } else {
              return Loading.buildLoadingWidget();
            }
          },
        ),
      ),
    );
  }

  Widget _buildMoviesWidget(MovieResponse data) {
    _movies.addAll(data.movies);
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
      return GridView.builder(
        scrollDirection: Axis.vertical,
        itemCount: _movies.length + 1,
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (orientation == Orientation.portrait) ? 3 : 4,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 1),),

        itemBuilder: (context, index) {
          if(index == _movies.length)
            return _isLoading ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Loading.buildLoadingWidget(),
              ],
            ) : Container();
          return Padding(
            padding: EdgeInsets.all(10),
            child: GestureDetector(
              onTap: () {

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
                  Container(
                      width: 120.0,
                      height: 170.0,
                      decoration: new BoxDecoration(
                        borderRadius:
                        BorderRadius.all(Radius.circular(4.0)),
                        shape: BoxShape.rectangle,
                        image: new DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(_movies[index].image)),
                      )),
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
      );
    }
  }
}
