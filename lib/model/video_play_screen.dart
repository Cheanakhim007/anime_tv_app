import 'package:better_player/better_player.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';



class VideoPlayScreen extends StatefulWidget {
  final String url;
  VideoPlayScreen({this.url});

  @override
  _VideoPlayScreenState createState() => _VideoPlayScreenState();
}

class _VideoPlayScreenState extends State<VideoPlayScreen> {
  BetterPlayerController _betterPlayerController;
  final FijkPlayer player = FijkPlayer();


  @override
  void initState() {
    super.initState();
    player.setDataSource(widget.url, autoPlay: true, showCover: true);
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      "${widget.url}",
      useHlsSubtitles: true,
      useHlsTracks: true,
      liveStream: false,
      headers: {
        "Accept" : "*/*",
        "Accept-Encoding" : "gzip, deflate, br",
        "Accept-Language" : "en-US,en;q=0.5",
        "Connection" : "keep-alive",
        "Host" : "www03.cloud9xx.com",
        "Origin" : "https://players.akamai.com",
        "Referer" : "https://gogo-play.net",
        "User-Agent" : "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:84.0) Gecko/20100101 Firefox/84.0",
      }
    );
    _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
          aspectRatio: 16 / 9,
          fullScreenByDefault: true,
          looping: true,
          allowedScreenSleep: false,
          startAt: const Duration(milliseconds: 300),
          controlsConfiguration: BetterPlayerControlsConfiguration(
           enableProgressBar: true,
            enableProgressText: true,
           enablePlayPause : true,
           showControlsOnInitialize : true,
           showControls : true,
           enableQualities : true,
          )
        ),
        betterPlayerDataSource: betterPlayerDataSource);
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: FijkView(
        player: player,
        width: double.infinity,
        height: double.infinity,
        fit: FijkFit.contain,
        fsFit : FijkFit.contain,
        color: Colors.black,
        onDispose: (value){
          player.dispose();
        },
      ),
    );
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: BetterPlayer(
        controller: _betterPlayerController,
      ),
    );
  }
}