import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:flutter_zoom_sdk_example/theme/colors.dart';
import 'package:flutter_zoom_sdk_example/theme/padding.dart';
import 'package:wakelock/wakelock.dart';

class PlayVideoPage extends StatefulWidget {
  final String judul;

  const PlayVideoPage({Key? key, required this.judul}) : super(key: key);
  @override
  _PlayVideoPageState createState() => _PlayVideoPageState();
}

class _PlayVideoPageState extends State<PlayVideoPage> {
  late VlcPlayerController _videoPlayerController;
  bool _isPlaying = true;
  String get judul => widget.judul;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VlcPlayerController.file(
        File("/storage/emulated/0/SmartSchool/$judul.mp4"), 
        hwAcc: HwAcc.FULL,
        autoPlay: true,
        options: VlcPlayerOptions());

    //setLandscape();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    //setAllOrientations();
    super.dispose();
  }

  Future setLandscape() async {
    // hide overlays statusbar
    // ignore: deprecated_member_use
    await SystemChrome.setEnabledSystemUIOverlays([]);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    await Wakelock.enable(); // keep device awake
  }

  Future setAllOrientations() async {
    // ignore: deprecated_member_use
    await SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);

    await Wakelock.disable();
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
    return Padding(
      padding: const EdgeInsets.only(top: padding, left: padding),
      child: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: kWhite,)),
    );
  }

  Widget buildVideo() {
    return Positioned.fill(
      child: Align(
      alignment: Alignment.center,
      child: VlcPlayer(controller: _videoPlayerController, aspectRatio: 16/9, placeholder: const Center(child: CircularProgressIndicator(color: kWhite,),),),
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
            Icon(Icons.fast_forward, color: kWhite.withOpacity(0.2),)
          ],
        ),
      ),
    );
  }
}
