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
  final FijkPlayer _player = FijkPlayer();

  @override
  void initState() {
    super.initState();
    _player.setDataSource(widget.url, autoPlay: true, showCover: true);
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      "${widget.url}",
    );
    _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
          aspectRatio: 16 / 9,
          autoPlay: true,
          looping: true,
          allowedScreenSleep: false,
          autoDetectFullscreenDeviceOrientation : true,
          controlsConfiguration: BetterPlayerControlsConfiguration(
           enableProgressBar: true,
           enableProgressText: true,
           enablePlayPause : true,
           showControls : true,
           enableQualities : true,
          )
        ),
        betterPlayerDataSource: betterPlayerDataSource);
  }

  @override
  void dispose() {
    _player.dispose();
    _player.release();
    _betterPlayerController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if(widget.url.contains(".m3u8")){
      return Container(
        alignment: Alignment.center,
        child: FijkView(
          player: _player,
          width: double.infinity,
          height: double.infinity,
          fit: FijkFit.ar16_9,
          fsFit : FijkFit.ar16_9,
          color: Colors.black,
          onDispose: (value){
            _player.dispose();
            _player.release();
          },
        ),
      );
    }else{
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: BetterPlayer(
          controller: _betterPlayerController,
        ),
      );
    }
  }
}