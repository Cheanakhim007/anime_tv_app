import 'package:anime_tv_app/widget/header.dart';
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
   /*   appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Style.Colors.mainColor,
          elevation: 0.0,
          centerTitle: true,
          title: Text("ANIME MOVIE", style: TextStyle(
              color: Colors.white
          ),),
        ),
      ),*/
      appBar: AppBar(
        backgroundColor: Style.Colors.mainColor,
        centerTitle: true,
        elevation: 0.0,
        leading: Icon(EvaIcons.menu2Outline, color: Colors.white,),
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
        ],
      ),
    );
  }
}