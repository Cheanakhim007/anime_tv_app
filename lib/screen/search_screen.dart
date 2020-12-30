import 'package:anime_tv_app/bloc/get_search_moview_bloc.dart';
import 'package:anime_tv_app/model/movie.dart';
import 'package:anime_tv_app/model/movie_repository.dart';
import 'package:anime_tv_app/repository/repository.dart';
import 'package:anime_tv_app/widget/error_widget.dart';
import 'package:anime_tv_app/widget/loading_widget.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/scaled_tile.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:anime_tv_app/style/theme.dart' as Style;

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchBarController<Movie> _searchBarController = SearchBarController();
  bool isReplay = false;
  // List<Movie> movies = [];


  @override
  void initState() {
    super.initState();
  }

  Future<List<Movie>> _getALlPosts(String text) async {
    await Future.delayed(Duration(seconds: text.length == 4 ? 4 : 1));
    final MovieRepository _repository = MovieRepository();
    MovieResponse response = await _repository.getSearch(text);
    return response.movies;
  }

  @override
  Widget build(BuildContext context) {
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
                  borderRadius: BorderRadius.circular(8),
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5)
              ),
              onSearch: _getALlPosts,
              searchBarController: _searchBarController,
              cancellationWidget: Text("Cancel", style: TextStyle(color: Colors.white)),
              onCancelled: () {
                print("Cancelled triggered");
              },
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              crossAxisCount: 3,
              onItemFound: (Movie movie, int index){
                 return Padding(
                  padding: EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {

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
                        Container(
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
                                fontSize: 11.0),
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

  Widget _buildMoviesWidget(List<Movie> moviesList) {
    List<Movie> movies = moviesList;
    print("ooooo ${movies.length}");
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
      return Expanded(
        child: Container(
          child: GridView.builder(
            scrollDirection: Axis.vertical,
            itemCount: movies.length,
            shrinkWrap: true,
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
          ),
        ),
      );
    }
  }
}
