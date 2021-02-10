import 'package:anime_tv_app/bloc/get_movies_byGenre_bloc.dart';
import 'package:anime_tv_app/model/genre.dart';
import 'package:anime_tv_app/screen/movies_by_genre.dart';
import 'package:flutter/material.dart';
import 'package:anime_tv_app/style/theme.dart' as Style;

class GenresTitle extends StatefulWidget {
  GenresTitle(this.genres);
  final List<Genre> genres ;
  @override
  _GenresTitleState createState() => _GenresTitleState();
}

class _GenresTitleState extends State<GenresTitle> with SingleTickerProviderStateMixin{
  TabController _tabController;
  int index = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: widget.genres.length);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        moviesByGenreBloc..drainStream();
      }else if(_tabController.index != _tabController.previousIndex){
        setState(() {
          index = _tabController.index;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        child: DefaultTabController(
          length: widget.genres.length,
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
                  onTap: (value){
                    setState(() {
                      index = value;
                    });
                  },
                  tabs: widget.genres.map((Genre genre) {
                    return Container(
                        padding: EdgeInsets.only(bottom: 15.0, top: 10.0),
                        child: new Text(genre.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            )));
                  }).toList(),
                ),
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: widget.genres.map((Genre genre) {
                return GenreMovies(
                  genreId: genre.id,
                  id: widget.genres[index].id,
                );
              }).toList(),
            ),
          ),
        )
    );
  }
}
