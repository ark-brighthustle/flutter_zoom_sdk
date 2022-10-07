import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:flutter_zoom_sdk_example/theme/padding.dart';

import '../../../theme/colors.dart';

// ignore: must_be_immutable
class VideoAmaliahPersonalPage extends StatefulWidget {
  String? fileVideo;
  VideoAmaliahPersonalPage({Key? key, required this.fileVideo}) : super(key: key);

  @override
  State<VideoAmaliahPersonalPage> createState() => _VideoAmaliahPersonalPageState();
}

class _VideoAmaliahPersonalPageState extends State<VideoAmaliahPersonalPage> {
 late VlcPlayerController _videoPlayerController;
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

  @override
  void initState() {
    loadVideo();
    super.initState();
  }

  @override
  void dispose() async {
    await _videoPlayerController.stopRendererScanning();
    await _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlack,
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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
      padding: const EdgeInsets.only(left: padding, top: padding),
      child: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: kWhite,)),
    );
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
           Icon(Icons.fast_forward, color: kWhite.withOpacity(0.2),)
          ],
        ),
      ),
    );
  }
}


