import 'package:anime_tv_app/widget/header.dart';
import 'package:anime_tv_app/widget/popular.dart';
import 'package:anime_tv_app/widget/recent.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:anime_tv_app/style/theme.dart' as Style;


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      appBar: AppBar(
        backgroundColor: Style.Colors.mainColor,
        centerTitle: true,
        elevation: 0.0,
        // leading: Icon(EvaIcons.menu2Outline, color: Colors.white,),
        title: Text("ANIME MOVIE"),
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              icon: Icon(EvaIcons.searchOutline, color: Colors.white,)
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Header(),
          PopularMovie(),
          RecentMovie(),
        ],
      ),
    );
  }
}