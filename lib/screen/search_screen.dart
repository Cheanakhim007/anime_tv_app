import 'package:anime_tv_app/model/movie.dart';
import 'package:anime_tv_app/model/movie_repository.dart';
import 'package:anime_tv_app/repository/repository.dart';
import 'package:anime_tv_app/screen/movie_detail_screen.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:anime_tv_app/style/theme.dart' as Style;
// git Password : Nakhim231298
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchBarController<Movie> _searchBarController = SearchBarController();
  List<Movie> _movies;
  bool isReplay = false;
  ScrollController _scrollController;
  int _countPage = 1;
  bool _stopRequest = false;
  bool _isLoading = false;
  String _text = "";
  // List<Movie> movies = [];


  @override
  void initState() {
    _movies = [];
    _stopRequest = false;
    _isLoading = false;
    _scrollController = new ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
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
        final MovieRepository _repository = MovieRepository();
        MovieResponse response = await _repository.getSearch(_text, countPage: _countPage);
        Future.delayed(Duration(seconds: 2)).then((value) {
          _isLoading = false;
          setState(() {});
        });
      }
    }
  }

  Future<List<Movie>> _getALlPosts(String text) async {
    _text = text;
    await Future.delayed(Duration(seconds: text.length == 4 ? 4 : 1));
    final MovieRepository _repository = MovieRepository();
    MovieResponse response = await _repository.getSearch(text, countPage: _countPage);
    // remove duplicates movies
    _movies = [...{...response.movies}];
    print("====>1 ${_movies.length}");
    print("====>2 ${_movies}");
    return _movies;
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      body: SafeArea(
        child: Stack(
          children: [
            SearchBar<Movie>(
              searchBarPadding: EdgeInsets.only(left: 60, right: 20),
              headerPadding: EdgeInsets.symmetric(horizontal: 10),
              listPadding: EdgeInsets.symmetric(horizontal: 10),
              textStyle: TextStyle(
                  color: Colors.white,
                  height: 1.4,
                  fontWeight: FontWeight.bold
              ),
              hintText: "Search...",
              icon: Icon(Icons.search, color: Colors.white,),
              hintStyle: TextStyle(
                  color: Colors.white70
              ),
              searchBarStyle: SearchBarStyle(
                  backgroundColor: Colors.grey[800],
                  borderRadius: BorderRadius.circular(14),
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5)
              ),
              onSearch: _getALlPosts,
              searchBarController: _searchBarController,
              emptyWidget: Center(
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Icon(Icons.search, color: Colors.white, size: 50),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Search not found", style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        height: 1.5
                    ),)
                  ],
                ),
              ),
              placeHolder: Center(
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Icon(Icons.search, color: Colors.white, size: 50),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Enter a few words to search in ANIME MOVIE", style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w400,
                      height: 1.5
                    ),)
                  ],
                ),
              ),
              cancellationWidget: Text("Cancel", style: TextStyle(color: Colors.white)),
              onCancelled: () {
                print("Cancelled triggered");
              },
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
              crossAxisCount: (orientation == Orientation.portrait) ? 3 : 4,
              onItemFound: (Movie movie, int index){
                 return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MovieDetail(movie: movie, label: "search")),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        movie.image == null ?
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
                          tag: movie.id + "search",
                          child: Container(
                              width: 120.0,
                              height: 170.0,
                              decoration: new BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                                shape: BoxShape.rectangle,
                                image: new DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(movie.image)),
                              )),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          width: 100,
                          child: Text(
                            movie.title,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 10.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Positioned(
                left: 0,
                top: 18,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                )
            ),
          ],
        ),
      ),
    );
  }
}
