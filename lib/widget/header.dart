
import 'package:anime_tv_app/model/movie.dart';
import 'file:///C:/Users/Nakhim007/Desktop/App/anime_tv_app/lib/screen/movie_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:anime_tv_app/style/theme.dart' as Style;
import 'package:page_indicator/page_indicator.dart';

class Header extends StatefulWidget {
  final List<Movie> movie;
  Header(this.movie);

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {

  PageController pageController = PageController(viewportFraction: 1, keepPage: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildHomeWidget(widget.movie);
  }

  Widget _buildHomeWidget(List<Movie> movies) {
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
          length: movies.length,
          indicatorSpace: 8.0,
          padding: const EdgeInsets.all(5.0),
          indicatorColor: Style.Colors.titleColor,
          indicatorSelectorColor: Style.Colors.secondColor,
          shape: IndicatorShape.circle(size: 5.0),
          child: PageView.builder(
            controller: pageController,
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MovieDetail(movie: movies[index], label: "header")),
                  );
                },
                child: Stack(
                  children: <Widget>[
                    Hero(
                      tag: movies[index].id + "header",
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
