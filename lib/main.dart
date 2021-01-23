import 'package:anime_tv_app/screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
      // home: SplashScreenApp(),
        home: FutureBuilder<RemoteConfig>(
          future: setupRemoteConfig(),
          builder: (BuildContext context, AsyncSnapshot<RemoteConfig> snapshot) {
            return snapshot.hasData
                ? SplashScreenApp()
                : SplashScreenApp();
          },
        )
    );
  }


  Future<RemoteConfig> setupRemoteConfig() async {
    await Firebase.initializeApp();
    try {
      final RemoteConfig remoteConfig = await RemoteConfig.instance;
      // Allow a fetch every millisecond. Default is 12 hours.
      remoteConfig.setConfigSettings(RemoteConfigSettings(minimumFetchIntervalMillis: 1));
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();
      print("----->3 ${remoteConfig.getString("minVersion")}");
      return remoteConfig;
    }on FetchThrottledException catch (exception) {
      print( "Error --->   $exception");
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will beused');
    }

  }
}

