import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:anime_tv_app/style/theme.dart' as Style;

import 'main_screen.dart';

class SplashScreenApp extends StatefulWidget {
  @override
  _SplashScreenAppState createState() => _SplashScreenAppState();
}

class _SplashScreenAppState extends State<SplashScreenApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 2,
      navigateAfterSeconds: new MainScreen(),
      title: new Text(
        'ANIME TV',
        style: new TextStyle(
            fontWeight: FontWeight.bold,
            height: 10,
            fontSize: 20.0,
            color: Colors.white),
      ),
        backgroundColor: Style.Colors.mainColor,
        loaderColor: Style.Colors.secondColor,
    );
  }
}
