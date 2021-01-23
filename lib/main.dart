import 'dart:io';

import 'package:anime_tv_app/model/app_config.dart';
import 'package:anime_tv_app/screen/splash_screen.dart';
import 'package:anime_tv_app/widget/loading_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  AppConfig appConfig = new AppConfig(
      softwareVersion: 1
  );
  AppConfigUtils.setAppConfig(appConfig);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreenApp(),
    );
  }
}

