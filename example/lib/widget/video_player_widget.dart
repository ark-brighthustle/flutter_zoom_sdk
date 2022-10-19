import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:flutter_zoom_sdk_example/theme/colors.dart';
import 'package:flutter_zoom_sdk_example/theme/padding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoPlayerWidget extends StatefulWidget {
  String? id;
  String? fileVideo;
  VideoPlayerWidget({Key? key, required this.id, required this.fileVideo}) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VlcPlayerController _videoPlayerController;
  late Stopwatch _stopwatch;
  bool _isPlaying = true;
  
  Future<void> initializePlayer() async {}

  loadVideo() {
     _videoPlayerController = VlcPlayerController.network(
      '${widget.fileVideo}',
      hwAcc: HwAcc.FULL,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
  }

   checkTimer() async {
    if(_videoPlayerController.value.isPlaying == true) {
      _stopwatch.start();
      print("Play");
    } else if (_videoPlayerController.value.isBuffering == true) {
      _stopwatch.stop();
      print("Pause");
    } else {
      _stopwatch.stop();
      print("Buffering");
    }
    if(formatTime(_stopwatch.elapsedMilliseconds) != "00:00:00") {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("id_video_class_room_guruss", widget.id.toString());
      preferences.setString("durasi_video_class_room_guruss", formatTime(_stopwatch.elapsedMilliseconds));
    }
  }

  String formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var hours = (secs ~/ 3600).toString().padLeft(2, '0');
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  void initState() {
    loadVideo();
    _stopwatch = Stopwatch();
    super.initState();
  }

  @override
  void dispose() async {
    await _videoPlayerController.stopRendererScanning();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBlack,
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              buildIconBack(),
              buildVideo(),
              buildPlayAndPause()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIconBack() {
    return IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: kWhite,));
  }

  Widget buildVideo() {
    return Positioned.fill(
      child: Align(
      alignment: Alignment.center,
      child: VlcPlayer(controller: _videoPlayerController, aspectRatio: 16/9, placeholder: Center(child: CircularProgressIndicator(color: kWhite,),),),
    ));
  }

  Widget buildPlayAndPause() {
    return Positioned.fill(
      bottom: padding,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.fast_rewind, color: kWhite.withOpacity(0.2),),
            IconButton(onPressed: (){
              if (_isPlaying) {
                setState(() {
                  _isPlaying = false;
                });
                _videoPlayerController.pause();
              } else {
                setState(() {
                  _isPlaying = true;
                });
                _videoPlayerController.play();
              }
            }, icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: kWhite,)),
            Icon(Icons.fast_forward, color: kWhite.withOpacity(0.2),),
          ],
        ),
      ),
    );
  }
}