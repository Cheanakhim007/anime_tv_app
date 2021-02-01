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
      seconds: 4,
      navigateAfterSeconds:  MainScreen(),
      image:  Image.asset('assets/icon/logo_anime.png', fit: BoxFit.cover, colorBlendMode: BlendMode.color, ),
      photoSize: 150,
        backgroundColor: Style.Colors.mainColor,
        loaderColor: Style.Colors.secondColor,
    );
  }
}
