import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';
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

  Future getLiveDelay() async {
    var response = await DelayStreamingService().getDataLiveDelay();
    if (!mounted) return;
    setState(() {
      liveDelayList = response;
    });
  }

  Future getSiswa() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      tingkat = preferences.getString("tingkat");
    });
  }

  var youtube_link;
  String _extractedLink = 'Loading...';

  Future<void> extractYoutubeLink() async {
    String link;
    try {
      link =
          await FlutterYoutubeDownloader.extractYoutubeLink(youtube_link, 18);
    } on PlatformException {
      link = 'Failed to Extract YouTube Video Link.';
    }
    if (!mounted) return;

    setState(() {
      _extractedLink = link;
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
          width: size.width,
          height: size.height,
          child: ListView.builder(
              itemCount: liveDelayList.length,
              itemBuilder: (context, i) {
                String ytId = liveDelayList[i].youtubeUrl.substring(32, 43);
                youtube_link = liveDelayList[i].youtubeUrl;

                DateTime dateTime = DateTime.parse(liveDelayList[i].createdAt);
                String createdAt = DateFormat('dd-MM-yyyy hh:mm').format(dateTime);

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
                          padding: const EdgeInsets.only(bottom: padding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
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
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 4, 12, 4),
                                  child: Text(liveDelayList[i].judul,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ))),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(12, 0, 12, 4),
                                child: Text(liveDelayList[i].deskripsi,
                                    style: const TextStyle(fontSize: 12)),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(12, 0, 0, 0),
                                    child: Text("Created : $createdAt",
                                        style: const TextStyle(
                                          fontSize: 10,
                                        )),
                                  ),
                                  liveDelayList[i].liveAt == null
                                      ? const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 12, 0),
                                          child: Text("Live : -",
                                              style: TextStyle(
                                                fontSize: 10,
                                              )),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.fromLTRB(
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
              })),
    );
  }

  Future<bool> _CekDurasiPlayYoutube() async{
    late EventClickModel _eventClickModel;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idSiswa = preferences.getInt('idSiswa').toString();
    String? idYoutube = preferences.getString('id_youtube_delay_streaming');
    String? durasiPutarYoutube = preferences.getString('durasi_putar_youtube_delay_streaming');
    if(idYoutube != null && durasiPutarYoutube != null) {
      var response = await DelayStreamingService().DurationPlay(
          idSiswa, idYoutube, durasiPutarYoutube);
      if(response != null && response != "Tidak ditemukan"){
        _eventClickModel = response;
        if (_eventClickModel.code == 200) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.remove("id_youtube_delay_streaming");
          preferences.remove("durasi_putar_youtube_delay_streaming");
          return true;
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("[Log Activity Error] Gagal terhubung ke server")));
          return false;
        }
      }else if(response == "Tidak ditemukan"){
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.remove("id_youtube_delay_streaming");
        preferences.remove("durasi_putar_youtube_delay_streaming");
        return true;
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("[Log Activity Error] Gagal terhubung ke server")));
        return false;
      }
    }else{
      return true;
    }
  }

  _bottomSheet(String idDelayStreaming, String kodeMapel, String judul, String deskripsi,
      String? gdriveUrl, String youtubeUrl, String ytId) async{
    bool showBottom = await _CekDurasiPlayYoutube();
    if(showBottom == true){
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
                                              builder: (context) => PlayYoutubeVideoWidget(jenis: "delay_streaming",id: idDelayStreaming,
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
                                      //extractYoutubeLink();
                                      //String link = "https://drive.google.com/file/d/1jSt5TulzvgoF3dllHti30LHxVJZzNPCv/view?usp=sharing";
                                      var idLink = gdriveUrl?.substring(32, 65);

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                               builder: (context) =>
                                                  ProgressDownload(
                                                    ytId: ytId,
                                                    videoUrl:
                                                        //"https://drive.google.com/uc?export=download&id=$idLink",
                                                        "https://www.googleapis.com/drive/v3/files/$idLink?alt=media&key=$ApiKeyGDrive",
                                                    imageUrl:
                                                        "https://img.youtube.com/vi/$ytId/0.jpg",
                                                    judul: judul,
                                                  )));
                                    },
                                    icon: const Icon(Icons.download,
                                        color: kCelticBlue),
                                    label: const Text('Download',
                                        style: TextStyle(color: kCelticBlue))),
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
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal terhubung ke server")));
    }
  }
}
