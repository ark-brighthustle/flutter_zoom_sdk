import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_sdk_example/models/classroom/soal_ujian/detail_hasil_ujian.dart';
import 'package:flutter_zoom_sdk_example/models/classroom/soal_ujian/jawaban_soal_ujian_model.dart';
import 'package:flutter_zoom_sdk_example/models/classroom/soal_ujian/response_jawaban_soal_ujian_model.dart';
import 'package:flutter_zoom_sdk_example/models/classroom/soal_ujian/soal_ujian_model.dart';
import 'package:flutter_zoom_sdk_example/models/jadwal_siswa/jadwal_siswa_model.dart';
import 'package:flutter_zoom_sdk_example/services/classroom/soal_ujian_service.dart';
import 'package:flutter_zoom_sdk_example/widget/open_image.dart';
import 'package:flutter_zoom_sdk_example/widget/video_player_widget.dart';
import 'package:flutter_zoom_sdk_example/widget/video_player_widget_log.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../theme/colors.dart';
import '../../../../theme/padding.dart';

// ignore: must_be_immutable
class HasilUjianElearningPage extends StatefulWidget {
  final int id;
  final String judul;
  final bool detailHasilUjian;
  HasilUjianElearningPage({
    Key? key,
    required this.id,
    required this.judul,
    required this.detailHasilUjian
  }) : super(key: key);

  @override
  State<HasilUjianElearningPage> createState() => _HasilUjianElearningPageState();
}

class _HasilUjianElearningPageState extends State<HasilUjianElearningPage> {
  Duration duration = const Duration(milliseconds: 500);
  final PageController _pageController = PageController();
  Curve curve = Curves.ease;
  List listSoalUjian = [];
  List listDetailHasilUjian = [];

  AudioPlayer audioPlayer = new AudioPlayer();
  Duration durationAudio = new Duration();
  Duration positionAudio = new Duration();
  bool playing = false;

  getSoalUjian() async {
    final response = await SoalUjianService().getDataSoalUjian(widget.id);
    if (!mounted) return;
    setState(() {
      var data = response['data'];
      listSoalUjian = data.map((p) => SoalUjianModel.fromJson(p)).toList();
    });
  }

  getDetailHasilUjian() async {
    final response = await SoalUjianService().getDetailHasilUjian(widget.id);
    if (!mounted) return;
    setState(() {
      var data = response['data'];
      listDetailHasilUjian = data.map((p) => DetailHasilUjianModel.fromJson(p)).toList();
    });
  }


  @override
  void initState() {
    getSoalUjian();
    if(widget.detailHasilUjian == true) {
      getDetailHasilUjian();
    }
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height,
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              iconBackPage(),
              buildSoalUjian(),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconBackPage() {
    return Padding(
      padding: const EdgeInsets.all(padding),
      child: Text(
        widget.judul,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget buildSoalUjian() {
    return Expanded(
      child: PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: listSoalUjian.length & listDetailHasilUjian.length,
          itemBuilder: (context, i) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: padding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Row(
                                children: [
                                  Text(
                                    "Soal ${listSoalUjian[i].id} / ${listSoalUjian.length}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                  Spacer(),
                                  Text(
                                      "Nilai ${listDetailHasilUjian[i].nilai}",
                                      style: const TextStyle(fontSize: 16)
                                  )
                                ],
                              )
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Text(
                                      "${listSoalUjian[i].soal}",
                                      style: const TextStyle(
                                          fontSize: 14, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  if(listSoalUjian[i].image != null)...[
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        child: GestureDetector(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => OpenImagePage(title: "Gambar soal no. ${listSoalUjian[i].id}", img: listSoalUjian[i].image))),
                                          child: Image.network(
                                            listSoalUjian[i].image,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  "Gagal Memuat Gambar!",
                                                  style: TextStyle(fontSize: 12),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                  if(listSoalUjian[i].video != null)...[
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        child: GestureDetector(
                                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayerWidget(title: "Vidio soal no. ${listSoalUjian[i].id}",
                                              fileVideo: listSoalUjian[i].video))),
                                          child: Container(
                                            width: 340,
                                            height: 150,
                                            color: Colors.grey,
                                            margin: const EdgeInsets.symmetric(horizontal: 8),
                                            child: Stack(
                                              children: [
                                                Align(
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                      Icons.play_circle,
                                                      size: 60,
                                                      color: kBlack.withOpacity(0.5),
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                  if(listSoalUjian[i].audio != null)...[
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        child: Container(
                                            width: 340,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(80),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              // mainAxisSize: MainAxisSize.max,
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                IconButton(
                                                    icon: Icon(
                                                      playing == false
                                                          ? Icons.play_arrow
                                                          : Icons.pause,
                                                      color: Colors.black,
                                                      size: 30,
                                                    ),
                                                    onPressed: () {
                                                      getAudio(listSoalUjian[i].audio);
                                                    }),
                                                // IconButton(
                                                //   icon: Icon(
                                                //     Icons.stop,
                                                //     color: Colors.black,
                                                //     size: 25,
                                                //   ),
                                                //   onPressed: () {},
                                                // ),
                                                Container(
                                                  width: 50,
                                                  child: Text(
                                                    "${setTimeDuration(durationAudio - positionAudio)}",
                                                  ),
                                                ),
                                                Flexible(
                                                  child: slider(),
                                                )
                                              ],
                                            )),
                                      ),
                                    ),
                                  ],
                                  if(widget.detailHasilUjian == true)...[
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            margin: const EdgeInsets.only(bottom: padding),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: listSoalUjian[i].jawaban ==
                                                    'a'
                                                    ? listSoalUjian[i].jawaban == listDetailHasilUjian[i].jawaban_benar
                                                    ? kGreen
                                                    : kRed
                                                    : listDetailHasilUjian[i].jawaban_benar == 'a'
                                                    ? kGreen
                                                    : kGrey),
                                            child: Text(
                                              "A. ${listSoalUjian[i].pilihanA}",
                                              style: const TextStyle(color: kBlack),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            margin: const EdgeInsets.only(bottom: padding),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: listSoalUjian[i].jawaban ==
                                                    'b'
                                                    ? listSoalUjian[i].jawaban == listDetailHasilUjian[i].jawaban_benar
                                                    ? kGreen
                                                    : kRed
                                                    : listDetailHasilUjian[i].jawaban_benar == 'b'
                                                    ? kGreen
                                                    : kGrey),
                                            child: Text(
                                              "B. ${listSoalUjian[i].pilihanB}",
                                              style: const TextStyle(color: kBlack),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            margin: const EdgeInsets.only(bottom: padding),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: listSoalUjian[i].jawaban ==
                                                    'c'
                                                    ? listSoalUjian[i].jawaban == listDetailHasilUjian[i].jawaban_benar
                                                    ? kGreen
                                                    : kRed
                                                    : listDetailHasilUjian[i].jawaban_benar == 'c'
                                                    ? kGreen
                                                    : kGrey),
                                            child: Text(
                                              "C. ${listSoalUjian[i].pilihanC}",
                                              style: const TextStyle(color: kBlack),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            margin: const EdgeInsets.only(bottom: padding),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                color: listSoalUjian[i].jawaban ==
                                                    'd'
                                                    ? listSoalUjian[i].jawaban == listDetailHasilUjian[i].jawaban_benar
                                                    ? kGreen
                                                    : kRed
                                                    : listDetailHasilUjian[i].jawaban_benar == 'd'
                                                    ? kGreen
                                                    : kGrey),
                                            child: Text(
                                              "D. ${listSoalUjian[i].pilihanD}",
                                              style: const TextStyle(color: kBlack),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            // borderRadius: BorderRadius.circular(8),
                                            color: kGrey
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(padding),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Penjelasan soal",
                                                style: const TextStyle(
                                                    fontSize: 14, fontWeight: FontWeight.bold, fontStyle:FontStyle.italic),
                                              ),
                                              if(listDetailHasilUjian[i].penjelasan_jawaban != null)...[
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                Text("${listDetailHasilUjian[i].penjelasan_jawaban}", style: const TextStyle(
                                                    fontSize: 13),),
                                              ],
                                              if(listDetailHasilUjian[i].penjelasan_jawaban != null)...[
                                                SizedBox(
                                                  height: 5.0,
                                                ),
                                                GestureDetector(
                                                  onTap: () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => OpenImagePage(title: "Gambar penjelasan soal no. ${listSoalUjian[i].id}", img: listDetailHasilUjian[i].gambar_penjelasan_jawaban))),
                                                  child: Image.network(
                                                    listDetailHasilUjian[i].gambar_penjelasan_jawaban,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) {
                                                      return Container(
                                                        alignment: Alignment.center,
                                                        child: const Text(
                                                          "Gagal Memuat Gambar!",
                                                          style: TextStyle(fontSize: 12),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ]
                                            ],
                                          ),
                                        )
                                    ),
                                  ]else...[
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            margin: const EdgeInsets.only(bottom: padding),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(
                                                    width: 2.0,
                                                    color: listSoalUjian[i].jawaban ==
                                                        'a'
                                                        ? kGreen
                                                        : kGrey),
                                                color: kGrey),
                                            child: Text(
                                              "A. ${listSoalUjian[i].pilihanA}",
                                              style: const TextStyle(color: kBlack),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            margin: const EdgeInsets.only(bottom: padding),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(
                                                    width: 2.0,
                                                    color: listSoalUjian[i].jawaban ==
                                                        'b'
                                                        ? kGreen
                                                        : kGrey),
                                                color: kGrey),
                                            child: Text(
                                              "B. ${listSoalUjian[i].pilihanB}",
                                              style: const TextStyle(color: kBlack),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            margin: const EdgeInsets.only(bottom: padding),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(
                                                    width: 2.0,
                                                    color: listSoalUjian[i].jawaban ==
                                                        'c'
                                                        ? kGreen
                                                        : kGrey),
                                                color: kGrey),
                                            child: Text(
                                              "C. ${listSoalUjian[i].pilihanC}",
                                              style: const TextStyle(color: kBlack),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            margin: const EdgeInsets.only(bottom: padding),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(
                                                    width: 2.0,
                                                    color: listSoalUjian[i].jawaban ==
                                                        'd'
                                                        ? kGreen
                                                        : kGrey),
                                                color: kGrey),
                                            child: Text(
                                              "D. ${listSoalUjian[i].pilihanD}",
                                              style: const TextStyle(color: kBlack),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                ),
                Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: kBlack26),
                                        borderRadius: BorderRadius.circular(4)),
                                    child: IconButton(
                                        onPressed: () => {
                                          _pageController.previousPage(
                                              duration: duration, curve: curve),
                                          audioPlayer.stop(),
                                          playing = false
                                        },
                                        icon: Padding(
                                          padding: EdgeInsets.only(left: 4),
                                          child: Icon(
                                            Icons.arrow_back_ios,
                                            size: 16,
                                          ),
                                        ))),
                                Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: kBlack26),
                                        borderRadius: BorderRadius.circular(4)),
                                    child: IconButton(
                                        onPressed: () =>
                                        {
                                          _pageController.nextPage(
                                            duration: duration, curve: curve),
                                          audioPlayer.stop(),
                                          playing = false
                                        },
                                        icon: const Padding(
                                          padding: EdgeInsets.only(left: 4),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 16,
                                          ),
                                        ))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ))
              ],
            );
          }),
    );
  }

  Widget slider(){
    return Slider.adaptive(
        min: 0.0,
        value: positionAudio.inSeconds.toDouble(),
        max: durationAudio.inSeconds.toDouble(),
        onChanged: (double value){
          setState(() {
            audioPlayer.seek(new Duration(seconds: value.toInt()));
          });
        }
    );
  }

  void getAudio(String url) async{
    if(playing){
      var res = await audioPlayer.pause();
      if(res == 1){
        setState(() {
          playing = false;
        });
      }
    }else{
      var res = await audioPlayer.play(url,isLocal: true);
      if(res == 1){
        setState(() {
          playing = true;
        });
      }
    }
    audioPlayer.onDurationChanged.listen((Duration dd) {
      setState(() {
        durationAudio = dd;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((Duration dd) {
      setState(() {
        positionAudio = dd;
      });
    });
    audioPlayer.onPlayerCompletion.listen((event) {
      setState(() {
        playing = false;
      });
    });
  }

  String setTimeDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}