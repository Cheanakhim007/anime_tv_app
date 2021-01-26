import 'dart:async';
import 'package:anime_tv_app/bloc/botton_navbar_bloc.dart';
import 'package:anime_tv_app/model/app_config.dart';
import 'package:anime_tv_app/screen/movies.dart';
import 'package:anime_tv_app/screen/genres_screen.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:anime_tv_app/style/theme.dart' as Style;
import 'package:url_launcher/url_launcher.dart';

import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  BottomNavBarBloc _bottomNavBarBloc;
  StreamSubscription<DataConnectionStatus> listener;
  var InternetStatus = "Unknown";
  var contentmessage = "Unknown";
  @override
  void initState() {
    super.initState();
    versionCheck(context);
    _bottomNavBarBloc = BottomNavBarBloc();
    checkConnection(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  checkConnection(BuildContext context) async{
    listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status){
        case DataConnectionStatus.connected:
          InternetStatus = "Connected to the Internet";
          contentmessage = "Connected to the Internet";
          print("------> ${InternetStatus}");
          break;
        case DataConnectionStatus.disconnected:
          InternetStatus = "Network Error ";
          contentmessage = "Please check your network condition and try again.";
          _showDialog(InternetStatus,contentmessage,context);
          break;
      }
    });
    return await DataConnectionChecker().connectionStatus;
  }

  void _showDialog(String title,String content ,BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: new Text(title),
              content: new Text(content),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: new Text("Close"))
              ]
          );
        }
    );
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
                return MoviesScreen(status: "movies");
              case NavBarItem.NEW:
                return GenresScreen();
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
                  // ignore: deprecated_member_use
                  title: Padding(padding: EdgeInsets.only(top: 5.0)),
                  icon: Icon(Icons.home,size: 28,)),
                BottomNavigationBarItem(
                  // ignore: deprecated_member_use
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
  versionCheck(context) async {
    await Firebase.initializeApp();
    try {
      final RemoteConfig remoteConfig = await RemoteConfig.instance;
      // Allow a fetch every millisecond. Default is 12 hours.
      remoteConfig.setConfigSettings(RemoteConfigSettings(minimumFetchIntervalMillis: 1));
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();


      String appUrl = remoteConfig.getString('appUrl');
      int currentVersion = int.parse(remoteConfig.getString('currentVersion'));
      int minVersion = int.parse(remoteConfig.getString('minVersion'));
      int maxVersion = int.parse(remoteConfig.getString('maxVersion'));
      String updateTitle = remoteConfig.getString('updateTitle');
      String updateMessage = remoteConfig.getString('updateMessage');

      print("-----> ${AppConfigUtils.appConfig}");
      print("-----> ${appUrl}");
      print("-----> ${currentVersion}");
      print("-----> ${updateTitle}");
      print("-----> ${updateMessage}");

      if( currentVersion >  AppConfigUtils.appConfig.softwareVersion){
        return  _showVersionDialog(
          context: context,
          url: appUrl,
          title: updateTitle,
          message: updateMessage
        );
      }
    }on FetchThrottledException catch (exception) {
      print( "Error --->   $exception");
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will beused');
    }

  }

  _showVersionDialog({BuildContext context, String url , String title, String message}) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String btnLabel = "Update Now";
        String btnLabelCancel = "Later";
        return WillPopScope(
          onWillPop: () async => false,
          child: CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text(btnLabel),
                onPressed: () => _launchURL(url),
              ),
             /* FlatButton(
                child: Text(btnLabelCancel),
                onPressed: () => Navigator.pop(context),
              ),*/
            ],
          ),
        );
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}