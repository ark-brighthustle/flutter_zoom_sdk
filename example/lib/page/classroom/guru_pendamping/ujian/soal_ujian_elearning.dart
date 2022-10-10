import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_zoom_sdk_example/services/classroom/soal_service.dart';
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
  late int duration;
  SoalUjianElearningPage(
      {Key? key,
      required this.id,
      required this.judul,
      required this.waktuMulai,
      required this.waktuSelesai,
      required this.duration})
      : super(key: key);

  @override
  State<SoalUjianElearningPage> createState() => _SoalUjianElearningPageState();
}

class _SoalUjianElearningPageState extends State<SoalUjianElearningPage> {
  final PageController _pageController = PageController();
  Duration duration = const Duration(milliseconds: 500);
  Curve curve = Curves.ease;
  List listSoalUjian = [];
  late Timer timer;
  String? a;
  String? b;
  String? c;
  String? d;

  getSoalUjian() async {
    final response = await SoalUjianService().getDataSoalUjian(widget.id);
    if (!mounted) return;
    setState(() {
      listSoalUjian = response;
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
                  "$minutesStr : $secondsStr ",
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
                          TextButton(
                              onPressed: () async {
                                SharedPreferences _preferences = await SharedPreferences.getInstance();
                                await _preferences.setString('a', a ?? "");
                                _pageController.nextPage(
                                    duration: duration, curve: curve);
                              },
                              child: Text(
                                "A. ${listSoalUjian[i].pilihanA}",
                                style: const TextStyle(color: kBlack),
                              )),
                          TextButton(
                              onPressed: () {
                                _pageController.nextPage(
                                    duration: duration, curve: curve);
                              },
                              child: Text("B. ${listSoalUjian[i].pilihanB}",
                                  style: const TextStyle(color: kBlack))),
                          TextButton(
                              onPressed: () {
                                _pageController.nextPage(
                                    duration: duration, curve: curve);
                              },
                              child: Text("C. ${listSoalUjian[i].pilihanC}",
                                  style: const TextStyle(color: kBlack))),
                          TextButton(
                              onPressed: () {
                                _pageController.nextPage(
                                    duration: duration, curve: curve);
                              },
                              child: Text("D. ${listSoalUjian[i].pilihanD}",
                                  style: const TextStyle(color: kBlack)))
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
                        buildNomorSoalDijawab(),
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
                                    onPressed: () => _pageController.previousPage(
                                        duration: duration, curve: curve),
                                    icon: const Padding(
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

  Widget buildNomorSoalDijawab() {
    return Expanded(
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: listSoalUjian.length,
          itemBuilder: (context, i) {
            return Container(
                width: 36,
                height: 36,
                margin: const EdgeInsets.only(bottom: 12, right: 8),
                decoration: BoxDecoration(
                    border: Border.all(color: kBlack26),
                    borderRadius: BorderRadius.circular(4)),
                child: Center(child: Text("${listSoalUjian[i].id}", style: const TextStyle(fontWeight: FontWeight.bold),)));
          }),
    );
  }
}
