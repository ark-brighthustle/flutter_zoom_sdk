import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/classroom/event_click_model.dart';
import '../../services/delay_streaming/delay_streaming_service.dart';
import '../../theme/colors.dart';
import '../../theme/padding.dart';
import '../../utils/config.dart';
import '../../widget/play_youtube_video_widget.dart';
import '../downloads/progress_download.dart';

class DetailDelayStreamingPage extends StatefulWidget {
  final String namaMapel;
  final String kodeMapel;
  const DetailDelayStreamingPage(
      {Key? key, required this.kodeMapel, required this.namaMapel})
      : super(key: key);

  @override
  State<DetailDelayStreamingPage> createState() =>
      _DetailDelayStreamingPageState();
}

class _DetailDelayStreamingPageState extends State<DetailDelayStreamingPage> {
  List liveDelayList = [];
  String? tingkat;
  bool? loadVideoYoutube;
  bool isLoading = true;
  bool cekKoneksi = true;

  Future getLiveDelay() async {
    setState(() {
      cekKoneksi = true;
      isLoading = true;
    });
    var response = await DelayStreamingService().getDataLiveDelay();
    if(response != null){
      if (!mounted) return;
      setState(() {
        liveDelayList = response;
        isLoading = false;
        cekKoneksi = true;
      });
    }else{
      setState(() {
        isLoading = false;
        cekKoneksi = false;
      });
    }
  }

  Future onRefresh() async {
    await getLiveDelay();
  }

  Future getSiswa() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      tingkat = preferences.getString("tingkat");
    });
  }

  

  @override
  void initState() {
    getLiveDelay();
    getSiswa();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.namaMapel,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: kWhite),
        ),
      ),
      body: SizedBox(
          width: size.width, height: size.height, child: buildLiveDelay()),
    );
  }

  Widget buildLiveDelay() {
    return RefreshIndicator(
        onRefresh: onRefresh,
        color: kCelticBlue,
        child: cekKoneksi == true
          ? isLoading == true
            ? const Center(child: CircularProgressIndicator())
            : liveDelayList.isEmpty
              ?  buildNoData()
              : ListView.builder(
              itemCount: liveDelayList.length,
              itemBuilder: (context, i) {
                String ytId = liveDelayList[i].youtubeUrl.substring(32, 43);

                DateTime dateTime = DateTime.parse(liveDelayList[i].createdAt);
                String createdAt = DateFormat('dd-MM-yyyy HH:mm').format(dateTime);

                return tingkat.toString() == liveDelayList[i].kodeTingkat &&
                    widget.kodeMapel == liveDelayList[i].kodeMataPelajaran
                    ? GestureDetector(
                    onTap: () {
                      _bottomSheet(
                          liveDelayList[i].id.toString(),
                          liveDelayList[i].kodeMataPelajaran,
                          liveDelayList[i].judul,
                          liveDelayList[i].deskripsi,
                          liveDelayList[i].gdriveUrl,
                          liveDelayList[i].youtubeUrl,
                          ytId);
                    },
                    child: Container(
                      width: 300,
                      color: kWhite,
                      padding:
                      const EdgeInsets.only(bottom: padding),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 168,
                            child: Stack(
                              children: [
                                ClipRRect(
                                  child: CachedNetworkImage(
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                    "https://img.youtube.com/vi/$ytId/0.jpg",
                                    errorWidget:
                                        (context, url, error) =>
                                    const Icon(Icons.error),
                                  ),
                                ),
                                Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.play_circle,
                                      size: 60,
                                      color:
                                      kBlack.withOpacity(0.5),
                                    ))
                              ],
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  12, 4, 12, 4),
                              child: Text(liveDelayList[i].judul,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ))),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                12, 0, 12, 4),
                            child: Text(liveDelayList[i].deskripsi,
                                style:
                                const TextStyle(fontSize: 12)),
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    12, 0, 0, 0),
                                child: Text("Created : $createdAt",
                                    style: const TextStyle(
                                      fontSize: 10,
                                    )),
                              ),
                              liveDelayList[i].liveAt == null
                                  ? const Padding(
                                padding: EdgeInsets.fromLTRB(
                                    0, 0, 12, 0),
                                child: Text("Live : -",
                                    style: TextStyle(
                                      fontSize: 10,
                                    )),
                              )
                                  : Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(
                                      0, 0, 12, 0),
                                  child: Text(
                                      "Live : ${DateFormat('dd-MM-yyyy').format(DateTime.parse(liveDelayList[i].liveAt))}",
                                      style: const TextStyle(
                                        fontSize: 10,
                                      ))),
                            ],
                          ),
                        ],
                      ),
                    ))
                    : Container();
              })
          : buildNoKoneksi()
    );
  }

  Future<bool> cekDurasiPlayYoutube() async {
    late EventClickModel _eventClickModel;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idSiswa = preferences.getInt('idSiswa').toString();
    String? idYoutube = preferences.getString('id_youtube_delay_streaming');
    String? durasiPutarYoutube =
        preferences.getString('durasi_putar_youtube_delay_streaming');
    if (idYoutube != null && durasiPutarYoutube != null) {
      var response = await DelayStreamingService()
          .durationPlay(idSiswa, idYoutube, durasiPutarYoutube);
      if (response != null && response != "Tidak ditemukan") {
        _eventClickModel = response;
        if (_eventClickModel.code == 200) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.remove("id_youtube_delay_streaming");
          preferences.remove("durasi_putar_youtube_delay_streaming");
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("[Log Activity Error] Gagal terhubung ke server")));
          return false;
        }
      } else if (response == "Tidak ditemukan") {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.remove("id_youtube_delay_streaming");
        preferences.remove("durasi_putar_youtube_delay_streaming");
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("[Log Activity Error] Gagal terhubung ke server")));
        return false;
      }
    } else {
      return true;
    }
  }

  _bottomSheet(
      String idDelayStreaming,
      String kodeMapel,
      String judul,
      String deskripsi,
      String? gdriveUrl,
      String youtubeUrl,
      String ytId) async {
    bool showBottom = await cekDurasiPlayYoutube();
    if (showBottom == true) {
      return showModalBottomSheet(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12))),
          context: context,
          builder: (_) {
            var ytId = youtubeUrl.substring(32, 43);

            return SizedBox(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: padding / 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.close,
                                color: kDarkBlack,
                              ))
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: padding / 4, horizontal: padding / 2),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 160,
                            height: 90,
                            child: ClipRRect(
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl:
                                    "https://img.youtube.com/vi/$ytId/0.jpg",
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Flexible(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                kodeMapel,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                judul,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                deskripsi,
                                style: const TextStyle(fontSize: 12),
                              )
                            ],
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                        margin: const EdgeInsets.all(padding / 2),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: kCelticBlue),
                                  child: TextButton.icon(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PlayYoutubeVideoWidget(
                                                        jenis: "delay_streaming",
                                                        id: idDelayStreaming,
                                                        youtubeId: ytId)));
                                      },
                                      icon: const Icon(Icons.play_arrow,
                                          color: kWhite),
                                      label: const Text('Play',
                                          style: TextStyle(color: kWhite)))),
                            ),
                            const SizedBox(width: 8),
                            gdriveUrl?.substring(32, 65) != null
                                ? Expanded(
                                    child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: kCelticBlue),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: TextButton.icon(
                                        onPressed: () async {
                                          var idLink = gdriveUrl?.substring(32, 65);

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProgressDownload(
                                                        ytId: ytId,
                                                        videoUrl: "https://www.googleapis.com/drive/v3/files/$idLink?alt=media&key=$ApiKeyGDrive",
                                                        imageUrl: "https://img.youtube.com/vi/$ytId/0.jpg",
                                                        judul: judul,
                                                      )));
                                        },
                                        icon: const Icon(Icons.download,
                                            color: kCelticBlue),
                                        label: const Text('Download',
                                            style:
                                                TextStyle(color: kCelticBlue))),
                                  ))
                                : Container()
                          ],
                        )),
                    const SizedBox(
                      height: 8,
                    )
                  ]),
            );
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Gagal terhubung ke server")));
    }
  }

  Widget buildNoData() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/no_data.svg',
              width: 90,
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Belum Ada data",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 8,
            ),
            TextButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kCelticBlue)),
              onPressed: onRefresh,
              child: const Text(
                "Refresh",
                style: TextStyle(color: Colors.white),
              ),
            )
          ]),
    );
  }

  Widget buildNoKoneksi() {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/no_connection.svg',
                width: 120,
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "Gagal terhubung keserver",
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(
                height: 8,
              ),
              TextButton(
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kCelticBlue)),
                onPressed: onRefresh,
                child: const Text(
                  "Refresh",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ])
    );
  }
}
