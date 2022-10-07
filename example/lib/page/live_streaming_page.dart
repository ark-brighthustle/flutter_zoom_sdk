import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_sdk/zoom_options.dart';
import 'package:flutter_zoom_sdk/zoom_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../theme/colors.dart';
import '../../../theme/padding.dart';
import '../../../utils/constant.dart';
import '../login.dart';
import '../services/jadwal_siswa/jadwal_siswa_service.dart';
import '../services/live_streaming/live_streaming_service.dart';
import '../theme/material_colors.dart';

class LiveStreamingPage extends StatefulWidget {
  const LiveStreamingPage({Key? key}) : super(key: key);

  @override
  _LiveStreamingPageState createState() => _LiveStreamingPageState();
}

class _LiveStreamingPageState extends State<LiveStreamingPage> {
  List liveList = [];
  List jadwalLiveList = [];
  String? username;
  String? token;
  late Timer timer;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("nama");
      token = preferences.getString("access_token");
    });
  }

  Future getLive() async {
    var response = await LiveStreamingService().getDataLiveStreaming();
    if (!mounted) return;
    setState(() {
      liveList = response;
    });
  }

  Future getJadwalLive() async {
    var response = await JadwalSiswaService().getDataJadwalSiswa();
    if (!mounted) return;
    setState(() {
      jadwalLiveList = response;
    });
  }

  Future onRefresh() async {
    await LiveStreamingService().getDataLiveStreaming();
  }

  @override
  void initState() {
    super.initState();
    getPref();
    getLive();
    getJadwalLive();
    onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          titleAppBarLiveStream,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: kWhite,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        color: kCelticBlue,
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: liveList.isEmpty ? notLive() : live()),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: colorCelticBlue,
          onPressed: bottomSheetJadwalLive,
          icon: const Icon(Icons.schedule),
          label: const Text("Lihat Jadwal")),
    );
  }

  Widget jadwalLive() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          width: 60,
          height: 8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: kBlack26),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: jadwalLiveList.length,
              itemBuilder: (context, i) {
                String jamMulai = jadwalLiveList[i].jamMulai.substring(0, 5);
                String jamSelesai = jadwalLiveList[i].jamSelesai.substring(0, 5);

                if (jadwalLiveList[i].hari == "Senin") {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: padding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: kGreen.withOpacity(0.3)
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            "${jadwalLiveList[i].hari}",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                       Text("Jam Ke- ${jadwalLiveList[i].jamKe}", style: const TextStyle(fontSize: 12),),
                        const Divider(thickness: 1,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "$jamMulai - $jamSelesai WITA",
                              style:
                                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            Flexible(
                              child: Text(
                                "${jadwalLiveList[i].namaMataPelajaran}",
                                style:
                                    const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.end,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                } else if (jadwalLiveList[i].hari == "Selasa") {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: padding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: kRed.withOpacity(0.3)
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            "${jadwalLiveList[i].hari}",
                            style: const TextStyle( fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                       Text("Jam Ke- ${jadwalLiveList[i].jamKe}", style: const TextStyle(fontSize: 12),),
                        const Divider(thickness: 1,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "$jamMulai - $jamSelesai WITA",
                              style:
                                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            Flexible(
                              child: Text(
                                "${jadwalLiveList[i].namaMataPelajaran}",
                                style:
                                    const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.end,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                } else if (jadwalLiveList[i].hari == "Rabu") {
                  return Container(
                     padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: padding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: kYellow.withOpacity(0.3)
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            "${jadwalLiveList[i].hari}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text("Jam Ke- ${jadwalLiveList[i].jamKe}", style: const TextStyle(fontSize: 12),),
                        const Divider(thickness: 1,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "$jamMulai - $jamSelesai WITA",
                              style:
                                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            Flexible(
                              child: Text(
                                "${jadwalLiveList[i].namaMataPelajaran}",
                                style:
                                    const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.end,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                } else if (jadwalLiveList[i].hari == "Kamis") {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: padding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: kCelticBlue.withOpacity(0.3)
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            "${jadwalLiveList[i].hari}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text("Jam Ke- ${jadwalLiveList[i].jamKe}", style: const TextStyle(fontSize: 12),),
                        const Divider(thickness: 1,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "$jamMulai - $jamSelesai WITA",
                              style:
                                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            Flexible(
                              child: Text(
                                "${jadwalLiveList[i].namaMataPelajaran}",
                                style:
                                    const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.end,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                } else if (jadwalLiveList[i].hari == "Jumat") {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: padding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: kOrange.withOpacity(0.3)
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            "${jadwalLiveList[i].hari}",
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                       Text("Jam Ke- ${jadwalLiveList[i].jamKe}", style: const TextStyle(fontSize: 12),),
                        const Divider(thickness: 1,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "$jamMulai - $jamSelesai WITA",
                              style:
                                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            Flexible(
                              child: Text(
                                "${jadwalLiveList[i].namaMataPelajaran}",
                                style:
                                    const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.end,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                }

                return const Text("Jadwal Tidak Ditemukan");
              }),
        ),
      ],
    );
  }

  bottomSheetJadwalLive() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return jadwalLive();
        });
  }

  Widget notLive() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/ilustrasi_no_live_stream.svg',
          width: 140,
        ),
        const SizedBox(
          height: 16,
        ),
        const Center(
          child: Text(
            'Ooops!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        const Center(
          child: Text('Belum Ada Live'),
        ),
      ],
    );
  }

  Widget live() {
    return ListView.builder(
        itemCount: liveList.length,
        itemBuilder: (context, i) {
          String jamMulai = liveList[i].jamMulai.substring(0, 5);
          String jamSelesai = liveList[i].jamSelesai.substring(0, 5);
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/1.23,
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue.withOpacity(0.3)
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Nama Mata Pelajaran',
                            style: TextStyle(fontSize: 12),
                          ),
                          Flexible(
                              child: Text("${liveList[i].namaMataPelajaran}",
                                  textAlign: TextAlign.end,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold))),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Kode Mata Pelajaran',
                            style: TextStyle(fontSize: 12),
                          ),
                          Flexible(
                              child: Text("${liveList[i].kodePelajaran}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold))),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Hari',
                            style: TextStyle(fontSize: 12),
                          ),
                          Flexible(
                              child: Text("${liveList[i].hari}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold))),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Waktu Mulai',
                            style: TextStyle(fontSize: 12),
                          ),
                          Flexible(
                              child: Text("$jamMulai WITA",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold))),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Waktu Selesai',
                            style: TextStyle(fontSize: 12),
                          ),
                          Flexible(
                              child: Text("$jamSelesai WITA",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Sedang Berlangsung..'),
                        const SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () => {
                            //var apiKey = 'XnBuR0XxS0G5sNuydUl35g';
                            //var meetingId = liveList[i].meetingId;
                            //var passcode = liveList[i].passcode;
                            {joinMeeting(context, liveList[i].meetingId, liveList[i].passcode)}
                          },
                          child: Container(
                              width: 90,
                              height: 90,
                              margin: const EdgeInsets.only(bottom: padding),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: kCelticBlue,
                              ),
                              child: const Center(
                                  child: Icon(
                                Icons.videocam_sharp,
                                size: 40,
                                color: kWhite,
                              ))),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  joinMeeting(BuildContext context, meetingId, passcode) {
    bool _isMeetingEnded(String status) {
      var result = false;

      if (Platform.isAndroid) {
        result = status == "MEETING_STATUS_DISCONNECTING" ||
            status == "MEETING_STATUS_FAILED";
      } else {
        result = status == "MEETING_STATUS_IDLE";
      }

      return result;
    }

    if (meetingId.isNotEmpty &&
        passcode.isNotEmpty) {
      ZoomOptions zoomOptions = ZoomOptions(
        domain: "zoom.us",
        appKey: "SCqq7P4YjhVnNxxdoXErV2JMqRveQ0yrNZCn", //API KEY FROM ZOOM
        appSecret: "4vlDdlhxwQcMu9QvYtColSwBpeeGdgcv0EfB", //API SECRET FROM ZOOM
      );
      var meetingOptions = ZoomMeetingOptions(
          userId: username.toString(),

          /// pass username for join meeting only --- Any name eg:- EVILRATT.
          meetingId: meetingId,

          /// pass meeting id for join meeting only
          meetingPassword: passcode,

          /// pass meeting password for join meeting only
          disableDialIn: "true",
          disableDrive: "true",
          disableInvite: "true",
          disableShare: "true",
          disableTitlebar: "false",
          viewOptions: "true",
          noAudio: "false",
          noDisconnectAudio: "false");

      var zoom = ZoomView();
      zoom.initZoom(zoomOptions).then((results) {
        if (results[0] == 0) {
          zoom.onMeetingStatus().listen((status) {
            if (kDebugMode) {
              print(
                  "[Meeting Status Stream] : " + status[0] + " - " + status[1]);
            }
            if (_isMeetingEnded(status[0])) {
              if (kDebugMode) {
                print("[Meeting Status] :- Ended");
              }
              timer.cancel();
            }
          });
          if (kDebugMode) {
            print("listen on event channel");
          }
          zoom.joinMeeting(meetingOptions).then((joinMeetingResult) {
            timer = Timer.periodic(const Duration(seconds: 2), (timer) {
              zoom.meetingStatus(meetingOptions.meetingId!).then((status) {
                if (kDebugMode) {
                  print("[Meeting Status Polling] : " +
                      status[0] +
                      " - " +
                      status[1]);
                }
              });
            });
          });
        }
      }).catchError((error) {
        if (kDebugMode) {
          print("[Error Generated] : " + error);
        }
      });
    } else {
      if (meetingId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Meeting ID Invalid."),
        ));
      } else if (passcode.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Passcode Invalid."),
        ));
      }
    }
  }
}
