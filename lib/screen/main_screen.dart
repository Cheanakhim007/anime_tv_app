import 'package:anime_tv_app/bloc/botton_navbar_bloc.dart';
import 'package:anime_tv_app/screen/movies.dart';
import 'package:flutter/material.dart';
import 'package:anime_tv_app/style/theme.dart' as Style;

import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  BottomNavBarBloc _bottomNavBarBloc;
  @override
  void initState() {
    super.initState();
    _bottomNavBarBloc = BottomNavBarBloc();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<NavBarItem>(
          stream: _bottomNavBarBloc.itemStream,
          initialData: _bottomNavBarBloc.defaultItem,
          // ignore: missing_return
          builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
            switch (snapshot.data) {
              case NavBarItem.HOME:
                return HomeScreen();
              case NavBarItem.MOVIE:
                return MoviesScreen();
              case NavBarItem.NEW:
                return testScreen();
            }
          },
        ),
      ),
      bottomNavigationBar: StreamBuilder(
        stream: _bottomNavBarBloc.itemStream,
        initialData: _bottomNavBarBloc.defaultItem,
        builder: (BuildContext context, AsyncSnapshot<NavBarItem> snapshot) {
          return ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
            ),
            child: BottomNavigationBar(
              backgroundColor: Style.Colors.mainColor,
              iconSize: 20,
              unselectedItemColor: Style.Colors.grey,
              selectedItemColor: Style.Colors.secondColor,
              unselectedFontSize: 9.5,
              selectedFontSize: 9.5,
              type: BottomNavigationBarType.fixed,
              currentIndex: snapshot.data.index,
              onTap: _bottomNavBarBloc.pickItem,
              items: [
                BottomNavigationBarItem(
                  title: Padding(padding: EdgeInsets.only(top: 5.0)),
                  icon: Icon(Icons.home,size: 28,)),
                BottomNavigationBarItem(
                  title: Padding(padding: EdgeInsets.only(top: 5.0)),
                  icon: Icon(Icons.local_movies, size: 28,)),
                BottomNavigationBarItem(
                  title: Padding(padding: EdgeInsets.only(top: 5.0)),
                  icon: Icon(Icons.movie_filter, size: 28,)),
              ],
            ),
          );
        },
      ),
    );
  }
  Widget testScreen() {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("New Screen")
        ],
      ),
    );
  }
}