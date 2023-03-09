import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayYoutubeVideoWidget extends StatefulWidget {
  final String jenis;
  final String id;
  final String youtubeId;
  const PlayYoutubeVideoWidget({Key? key, required this.jenis, required this.id, required this.youtubeId}) : super(key: key);

  @override
  _PlayYoutubeVideoWidgetState createState() => _PlayYoutubeVideoWidgetState();
}

class _PlayYoutubeVideoWidgetState extends State<PlayYoutubeVideoWidget> {
  late YoutubePlayerController _controller;
  late PlayerState _playerState;
  late Stopwatch _stopwatch;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeId,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        forceHD: false,
        enableCaption: true,
        showLiveFullscreenButton: true,
      ),
    )..addListener(listener);
    _stopwatch = Stopwatch();
  }

  String formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  checkTimer() async {
    if(_playerState == PlayerState.playing) {
      _stopwatch.start();
      print("Play");
    } else if (_playerState == PlayerState.paused) {
      _stopwatch.stop();
      print("Pause");
    } else if (_playerState == PlayerState.buffering) {
      _stopwatch.stop();
      print("Buffering");
    }
    if(formatTime(_stopwatch.elapsedMilliseconds) != "00:00:00") {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("id_youtube_" + widget.jenis, widget.id);
      preferences.setString("durasi_putar_youtube_" + widget.jenis, formatTime(_stopwatch.elapsedMilliseconds));
    }
  }

  void listener() {
    setState(() {
      _playerState = _controller.value.playerState;
    });
    checkTimer();
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return WillPopScope(
    //   onWillPop: () {
    //     print("DATA = "+DurationPlayYoutube.toString());
    //     Navigator.pop(context, false);
    //     return Future.value(false);
    //   },
    //   child: SafeArea(
    //       child: AspectRatio(
    //         aspectRatio: 2.2 / 1,
    //         child: _controller != null
    //             ? YoutubePlayer(
    //           controller: _controller,
    //           showVideoProgressIndicator: true,
    //           progressIndicatorColor: Colors.blueAccent,
    //           topActions: <Widget>[
    //             SizedBox(width: 8.0),
    //             Expanded(
    //               child: Text(
    //                 _controller.metadata.title,
    //                 style: TextStyle(
    //                   color: Colors.white,
    //                   fontSize: 18.0,
    //                 ),
    //                 overflow: TextOverflow.ellipsis,
    //                 maxLines: 1,
    //               ),
    //             ),
    //           ],
    //           onEnded: (data) {},
    //         )
    //             : const Center(child: CircularProgressIndicator()),
    //       )),
    // );
    return SafeArea(
        child: AspectRatio(
          aspectRatio: 2.2 / 1,
          child: _controller != null
              ? YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blueAccent,
            topActions: <Widget>[
              SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  _controller.metadata.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
            onEnded: (data) {},
          )
              : const Center(child: CircularProgressIndicator()),
        )
    );
  }
}