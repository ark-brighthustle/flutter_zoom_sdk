import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_zoom_sdk_example/models/classroom/soal_ujian/jawaban_soal_ujian_model.dart';
import 'package:flutter_zoom_sdk_example/models/classroom/soal_ujian/response_jawaban_soal_ujian_model.dart';
import 'package:flutter_zoom_sdk_example/models/classroom/soal_ujian/soal_ujian_model.dart';
import 'package:flutter_zoom_sdk_example/services/classroom/soal_ujian_service.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../theme/colors.dart';
import '../../../../theme/padding.dart';

// ignore: must_be_immutable
class SoalUjianElearningPage extends StatefulWidget {
  final int id;
  final String judul;
  final String waktuMulai;
  final String waktuSelesai;
  late int duration = 0;
  SoalUjianElearningPage(
      {Key? key,
        required this.id,
        required this.judul,
        required this.waktuMulai,
        required this.waktuSelesai,})
      : super(key: key);

  @override
  State<SoalUjianElearningPage> createState() => _SoalUjianElearningPageState();
}

class _SoalUjianElearningPageState extends State<SoalUjianElearningPage> {
  final PageController _pageController = PageController();
  Duration duration = const Duration(milliseconds: 500);
  Curve curve = Curves.ease;
  List listSoalUjian = [];
  Map<String,String>data = {"elearning_id": '20'};
  ResponseJawabanSoalUjianModel? responseJawabanSoalUjian;
  JawabanSoalUjianModel? jawabanSoalUjianModel;
  late Timer timer;
  Future<JawabanSoalUjianModel>? _future;

  // saveJawaban() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   List<String> stringList = [];
  //   stringList.add(jawaban);
  //
  //   setState(() {
  //     preferences.setStringList(
  //         "save_jawaban", stringList); // qrText need to be a Stringlist
  //     svJawaban = preferences.getStringList("save_jawaban")!;
  //   });
  // }

  getSoalUjian() async {
    final response = await SoalUjianService().getDataSoalUjian(widget.id);
    if (!mounted) return;
    DateTime dtmulai = DateTime.parse(widget.waktuMulai);
    DateTime dtsekarang = DateTime.parse(response['waktu_sekarang']);
    Duration diff = dtsekarang.difference(dtmulai);
    // print("Waktu Mulai "+widget.waktuMulai);
    // print("Waktu Sekarang "+response['waktu_sekarang']);
    if(!diff.isNegative){
      DateTime dtselesai = DateTime.parse(widget.waktuSelesai);
      if(DateFormat('dd-MM-yyyy').format(dtsekarang) == DateFormat('dd-MM-yyyy').format(dtselesai)){
        Duration waktuselesai = dtselesai.difference(dtsekarang);
        // print("Waktu Sekarang "+response['waktu_sekarang']);
        // print("Waktu Selesai "+widget.waktuSelesai);
        setState((){
          widget.duration = waktuselesai.inSeconds;
        });
      }else{
        // Navigator.pop(context);
      }
    }
    setState(() {
      var data = response['data'];
      listSoalUjian = data.map((p) => SoalUjianModel.fromJson(p)).toList();
    });
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (widget.duration > 0) {
        if (!mounted) return;
        setState(() {
          widget.duration--;
        });
      } else {
        stopTimer();
        //endQuiz();
      }
    });
  }

  stopTimer() {
    timer.cancel();
  }

  alertDialogHasilUjian() {
    showDialog(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AlertDialog(
                  content: buildJawabanSoalUjian()
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    getSoalUjian();
    if (mounted) {
      startTimer();
      widget.waktuMulai;
    }
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
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
    int minutes = (widget.duration / 60).truncate();
    int hours = (widget.duration / 3600).truncate();
    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (widget.duration % 60).toString().padLeft(2, '0');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(padding),
          child: Text(
            widget.judul,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: padding),
          child: Row(
            children: [
              const Icon(
                Icons.timer,
                color: kCelticBlue,
                size: 16,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  "$hoursStr : $minutesStr : $secondsStr ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildSoalUjian() {
    return Expanded(
      child: PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: listSoalUjian.length,
          itemBuilder: (context, i) {
            return Stack(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: padding),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Text(
                          "Soal ${listSoalUjian[i].id} / ${listSoalUjian.length}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          "${listSoalUjian[i].soal}",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                data.addAll({"jawaban[${listSoalUjian[i].id}]":'a'});
                              });
                              _pageController.nextPage(
                                  duration: duration, curve: curve);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              margin: const EdgeInsets.only(bottom: padding),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      width: 2.0,
                                      color: data['jawaban[${listSoalUjian[i].id}]'] == 'a'
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
                            onTap: () {
                              setState(() {
                                data.addAll({"jawaban[${listSoalUjian[i].id}]":'b'});
                              });
                              _pageController.nextPage(
                                  duration: duration, curve: curve);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              margin: const EdgeInsets.only(bottom: padding),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      width: 2.0,
                                      color:data['jawaban[${listSoalUjian[i].id}]'] == 'b'
                                      ? kGreen
                                      : kGrey
                                  ),
                                  color: kGrey),
                              child: Text(
                                "B. ${listSoalUjian[i].pilihanB}",
                                style: const TextStyle(color: kBlack),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                data.addAll({"jawaban[${listSoalUjian[i].id}]":'c'});
                              });
                              _pageController.nextPage(
                                  duration: duration, curve: curve);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              margin: const EdgeInsets.only(bottom: padding),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      width: 2.0,
                                      color: data['jawaban[${listSoalUjian[i].id}]'] == 'c'
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
                            onTap: () {
                              setState(() {
                                data.addAll({"jawaban[${listSoalUjian[i].id}]":'d'});
                              });
                              _pageController.nextPage(
                                  duration: duration, curve: curve);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              margin: const EdgeInsets.only(bottom: padding),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      width: 2.0,
                                      color: data['jawaban[${listSoalUjian[i].id}]'] == 'd'
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
                    ],
                  ),
                ),
                Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: double.infinity,
                        height: 90,
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
                                        onPressed: () =>
                                        {
                                          _pageController.previousPage(
                                              duration: duration, curve: curve),
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
                                        onPressed: () => _pageController.nextPage(
                                            duration: duration, curve: curve),
                                        icon: const Padding(
                                          padding: EdgeInsets.only(left: 4),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 16,
                                          ),
                                        ))),
                                GestureDetector(
                                  onTap: () async {
                                    var response = await SoalUjianService().createJawabanSoalUjian(data);

                                    if (response != null) {
                                      setState(() {
                                        jawabanSoalUjianModel = response.data;
                                      });

                                      alertDialogHasilUjian();
                                    } else {
                                      showScaffoldMessage();
                                    }
                                    //alertDialogHasilUjian();
                                  },
                                  child: Container(
                                      width: 90,
                                      height: 36,
                                      decoration: BoxDecoration(
                                          color: kGreen,
                                          borderRadius: BorderRadius.circular(4)),
                                      child: const Center(
                                          child: Text(
                                            "Check",
                                            style: TextStyle(color: kWhite),
                                          ))),
                                ),
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

  Widget buildJawabanSoalUjian() {
    return SizedBox(
      width: 400,
      height: 400,
      child: FutureBuilder<JawabanSoalUjianModel>(
          future: _future,
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(),);
            } else if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error}"),);
            } else if (!snapshot.hasData) {
              return const Center(child: Text("Belum ada data"),);
            }

            return Text("${snapshot.data?.nilai}");
          })),
    );
  }

  showScaffoldMessage() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Maaf, Terjadi Kesalahan, Server Tidak Merespon")));
  }
}
