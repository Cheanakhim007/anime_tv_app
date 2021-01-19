import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class VideoPlayScreen extends StatefulWidget {
  final String url;
  VideoPlayScreen({this.url});

  @override
  _VideoPlayScreenState createState() => _VideoPlayScreenState();
}

class _VideoPlayScreenState extends State<VideoPlayScreen> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: BetterPlayer.network(
        "${widget.url}",
        betterPlayerConfiguration: BetterPlayerConfiguration(
          aspectRatio: 16 / 9,
          fullScreenByDefault: true,
        ),
      ),
    );
  }
}
