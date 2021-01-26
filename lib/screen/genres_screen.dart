
import 'package:anime_tv_app/bloc/get_genres_bloc.dart';
import 'package:anime_tv_app/bloc/get_movies_byGenre_bloc.dart';
import 'package:anime_tv_app/model/genre.dart';
import 'package:anime_tv_app/model/genre_response.dart';
import 'package:anime_tv_app/model/movie.dart';
import 'package:anime_tv_app/model/movie_repository.dart';
import 'package:anime_tv_app/screen/movie_detail_screen.dart';
import 'package:anime_tv_app/screen/movies_by_genre.dart';
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

class _GenresScreenState extends State<GenresScreen>  with SingleTickerProviderStateMixin{
  List<Movie> _movies;
  ScrollController _scrollController;
  TabController _tabController;
  int _countPage = 1;
  bool _stopRequest = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    genresBloc..getGenres();
    _movies = [];
    _stopRequest = false;
    _isLoading = false;
    _scrollController = new ScrollController();
    _scrollController.addListener(_scrollListener);
    _tabController = TabController(vsync: this, length: 44);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        moviesByGenreBloc..drainStream();
      }
    });
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
        setState(() {
          _isLoading = true;
        });
        // getData();
        Future.delayed(Duration(seconds: 2)).then((value) {
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
        child: ListView(
          children: [
         StreamBuilder<GenreResponse>(
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
        ),
          ],
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
      return Container(
          height: 307.0,
          child: DefaultTabController(
            length: genres.length,
            child: Scaffold(
              backgroundColor: Style.Colors.mainColor,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(50.0),
                child: AppBar(
                  backgroundColor: Style.Colors.mainColor,
                  bottom: TabBar(
                    controller: _tabController,
                    indicatorColor: Style.Colors.secondColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorWeight: 3.0,
                    unselectedLabelColor: Style.Colors.titleColor,
                    labelColor: Colors.white,
                    isScrollable: true,
                    tabs: genres.map((Genre genre) {
                      return Container(
                          padding: EdgeInsets.only(bottom: 15.0, top: 10.0),
                          child: new Text(genre.name.toUpperCase(), style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          )));
                    }).toList(),
                  ),
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                physics: NeverScrollableScrollPhysics(),
                children: genres.map((Genre genre) {
                  return GenreMovies(genreId: genre.id,);
                }).toList(),
              ),
            ),
          ));
  }


  Widget _buildMoviesWidget(MovieResponse data) {
    if(data.movies.length == 0)
      _stopRequest = true;
    if(_movies.toString() != data.movies.toString())
      _movies.addAll(data.movies);
    // remove duplicates movies
    _movies = [...{..._movies}];
    if (_movies.length == 0) {
      return BuildError.buildErrorWidget("No Movie", retry: (){
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Center(child: CircularProgressIndicator());
            });
        // getData();
        Future.delayed(Duration(seconds: 1), (){
          setState(() {
            Navigator.pop(context);
          });
        });
      });
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
                        MaterialPageRoute(builder: (context) => MovieDetail(movie:  _movies[index])),
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
                          tag: _movies[index].id ,
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
