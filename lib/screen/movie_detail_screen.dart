import 'package:anime_tv_app/bloc/get_detail_movie_bloc.dart';
import 'package:anime_tv_app/model/movie.dart';
import 'package:anime_tv_app/model/movie_repository.dart';
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
  _MovieDetailState(this.movie);
  final Movie movie;
  String firstHalf;
  String secondHalf;

  bool flag = true;

  @override
  void initState() {
    moviesDetailBloc..getMoviesDetail(id: movie.id);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      body: new Builder(
          builder: (context){
            return new SliverFab(
                floatingPosition: FloatingPosition(right: 20),
                floatingWidget: Container(),
                expandedHeight: 300,
                slivers: <Widget>[
                   SliverAppBar(
                    backgroundColor: Style.Colors.mainColor,
                    expandedHeight: 300.0,
                    pinned: true,
                    flexibleSpace: new FlexibleSpaceBar(
                        title: Text(
                          movie.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.normal),
                        ),
                        background: Stack(
                          children: <Widget>[
                            Hero(
                            tag : movie.id + widget.label,
                              child: Container(
                                decoration: new BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  image: new DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(movie.image)),
                                ),
                                child: new Container(
                                  decoration: new BoxDecoration(
                                      color: Colors.black.withOpacity(0.5)),
                                ),
                              ),
                            ),
                            Container(
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
                            ),
                          ],
                        )),
                  ),
                    SliverPadding(
                        padding: EdgeInsets.all(0.0),
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
                                    return Loading.buildLoadingWidget();
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
    if (des.length > 50) {
      firstHalf = des.substring(0, 50);
      secondHalf = des.substring(50, des.length);
    } else {
      firstHalf = des;
      secondHalf = "";
    }
    List<String> episode = movie.episode.last.toString().split("-");

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
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                new Text(flag ? (firstHalf + "...") : (firstHalf + secondHalf),
                    style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, height: 1.5)),
                SizedBox(height: 6),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          flag = !flag;
                        });
                      },
                      child: new Text(
                        flag ? "show more" : "show less",
                        style: new TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
              Text(
              "Episodes",
              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold, color: Colors.white)),
             SizedBox(height: 8),
              Row(
                children: episode.map((e){
                  return Container(
                    margin: EdgeInsets.only(left: episode.indexOf(e) == 0 ? 0 : 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Style.Colors.secondColor, //                   <--- border color
                          width: 2.0
                      ),
                      borderRadius: BorderRadius.all(
                          Radius.circular(8) //                 <--- border radius here
                      ),
                    ),
                    child: Container(
                        width: 50,
                        height: 35,
                        alignment: Alignment.center,
                        child: new Text(e, style: new TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                  );
                }).toList(),
              ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildVideoWidget() {
    return FloatingActionButton(
      backgroundColor: Style.Colors.secondColor,
      onPressed: () {

      },
      child: Icon(Icons.play_arrow),
    );
  }
}
