import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MicroVideoPlayer extends StatefulWidget {
  final _microVideoUrl;
  MicroVideoPlayer(this._microVideoUrl);
  @override
  _MicroVideoPlayerState createState() => _MicroVideoPlayerState(_microVideoUrl);
}

class _MicroVideoPlayerState extends State<MicroVideoPlayer> {
  final _microVideoUrl;
  _MicroVideoPlayerState(this._microVideoUrl);
  YoutubePlayerController _controller;
  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: "wEHajHLaiHc",
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
//      onExitFullScreen: () {
//        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
//        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
//      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 25.0,
            ),
            onPressed: () {

            },
          ),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: (data) {

        },
      ),
    builder: (context, player) => Scaffold(
      appBar: AppBar(
        title: Text("Micro Video"),
      ),
      body: Container(
        child: player,
      ),
    )

    );
  }
}
