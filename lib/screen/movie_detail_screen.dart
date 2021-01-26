import 'package:anime_tv_app/bloc/get_detail_movie_bloc.dart';
import 'package:anime_tv_app/model/movie.dart';
import 'package:anime_tv_app/model/movie_repository.dart';
import 'package:anime_tv_app/model/video_play.dart';
import 'file:///C:/Users/Nakhim007/Desktop/App/anime_tv_app/lib/screen/video_play_screen.dart';
import 'package:anime_tv_app/repository/repository.dart';
import 'package:anime_tv_app/widget/error_widget.dart';
import 'package:anime_tv_app/widget/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:anime_tv_app/style/theme.dart' as Style;
import 'package:sliver_fab/sliver_fab.dart';


class MovieDetail extends StatefulWidget {
  MovieDetail({Key key, @required this.movie, this.label}) : super(key: key);
  final Movie movie;
  final String label;

  @override
  _MovieDetailState createState() => _MovieDetailState(movie);
}

class _MovieDetailState extends State<MovieDetail> {
  _MovieDetailState(this._movie);
  final Movie _movie;
  String firstHalf;
  String secondHalf;
  bool flag = true;
  Map<String, bool> currentPaly = new Map();

  @override
  void initState() {
    moviesDetailBloc..getMoviesDetail(id: _movie.id);
    super.initState();
  }

  @override
  void dispose() {
    moviesDetailBloc..drainStream();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      body: Builder(
          builder: (context){
            return  SliverFab(
                floatingPosition: FloatingPosition(right: 20),
                floatingWidget: Container(),
                expandedHeight: 300,
                slivers: <Widget>[
                   SliverAppBar(
                    backgroundColor: Style.Colors.mainColor,
                    expandedHeight: 300.0,
                    pinned: true,
                    flexibleSpace:  FlexibleSpaceBar(
                        title: Text(
                          _movie.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.normal),
                        ),
                        background: Stack(
                          children: <Widget>[
                            Hero(
                            tag : _movie.id + widget.label,
                              child: Container(
                                decoration:  BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image:  DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(_movie.image)),
                                ),
                                child:  Container(
                                  decoration:  BoxDecoration(
                                      color: Colors.black.withOpacity(0.5)),
                                ),
                              ),
                            ),
                 /*           Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    stops: [
                                      0.2,
                                      0.0
                                    ],
                                    colors: [
                                      Colors.black.withOpacity(0.2),
                                      Colors.black.withOpacity(0.0)
                                    ]),
                              ),
                            ),*/
                          ],
                        )),
                  ),
                    SliverPadding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              StreamBuilder<MovieResponse>(
                                stream: moviesDetailBloc.subject.stream,
                                builder: (context, AsyncSnapshot<MovieResponse> snapshot){
                                  if (snapshot.hasData) {
                                    if (snapshot.data.error != null && snapshot.data.error.length > 0) {
                                      return BuildError.buildErrorWidget(snapshot.data.error, retry: (){
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Center(child: CircularProgressIndicator());
                                            });
                                        moviesDetailBloc..getMoviesDetail();
                                        Future.delayed(Duration(seconds: 1), (){
                                          setState(() {
                                            Navigator.pop(context);
                                          });
                                        });
                                      });
                                    }
                                    return buildSliverBody(snapshot.data);
                                  } else if (snapshot.hasError) {
                                    return BuildError.buildErrorWidget(snapshot.data.error, retry: (){
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Center(child: CircularProgressIndicator());
                                          });
                                      moviesDetailBloc..getMoviesDetail();
                                      Future.delayed(Duration(seconds: 1), (){
                                        setState(() {
                                          Navigator.pop(context);
                                        });
                                      });
                                    });
                                  } else {
                                    return Container(
                                         height: 300,
                                         alignment: Alignment.center,
                                        child: Loading.buildLoadingWidget()
                                    );
                                  }
                                },
                              )
                        ]))),
                ],

            );
          }
      ),
    );
  }

  Widget buildSliverBody(MovieResponse data) {
    Movie movie = data.movies[0];
    String des = movie.description[1]['value'] ?? "";

    if (des.length > 100) {
      firstHalf = des.substring(0, 100);
      secondHalf = des.substring(100, des.length);
    } else {
      firstHalf = des;
      secondHalf = "";
    }
    List<int> episode = [];
    if(movie.episode.isNotEmpty){
      int size = int.parse(movie.episode);
      episode = new List<int>.generate(size, (i) => i + 1);
      episode.sort((a,b) => b.compareTo(a));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Visibility(
          visible: movie.description != null && movie.description[3] != null && movie.description[3].toString().isNotEmpty,
          child: Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 5),
                Icon(Icons.new_releases, color: Colors.white),
                SizedBox(width: 5),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text("${movie.description[3]['value']}", style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          ),
        ),
        Visibility(
          visible: des.isNotEmpty,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                 Text(flag ? (firstHalf) : (firstHalf + secondHalf),
                    style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, height: 1.5)),
                 Visibility(
                   visible: firstHalf.length > 50,
                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          setState(() {
                            flag = !flag;
                          });
                        },
                        child: Container(
                         padding: EdgeInsets.all(4),
                          child:  Text(
                            flag ? "show more" : "show less",
                            style:  TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                ),
                 ),
              ],
            ),
          ),
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left:  8),
                child: Text(
                    "Episodes",
                    style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Row(
                    children: episode.map((e){
                      return GestureDetector(
                        onTap: () async {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Center(child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Style.Colors.secondColor),
                                  strokeWidth: 4.0,
                                ),);
                              });
                          currentPaly = new Map();
                          currentPaly[e.toString()] = true;
                          final MovieRepository repository = MovieRepository();
                          VideoPlay response = await repository.getMoviesPlay(_movie.id + "-episode-" + e.toString());
                          Navigator.pop(context);
                          if(response != null && response.source.isNotEmpty){
                                String url = response.source[0];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => VideoPlayScreen(url: url)),
                                );
                              }
                          setState(() {});
                        },
                        child: Container(
                          margin: EdgeInsets.only(left:  8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: currentPaly[e.toString()] ?? false ? Style.Colors.secondColor : Colors.grey, //                   <--- border color
                                width: 2.0
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(8) //                 <--- border radius here
                            ),
                          ),
                          child: Container(
                              width: 90,
                              height: 50,
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                   Text(e.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                   Text("EP", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                ],
                              )),
                        ),
                      );
                    }).toList(),
                  ),
                  ],
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        )
      ],
    );
  }
}
