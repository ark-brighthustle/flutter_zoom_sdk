import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/classroom/event_click_model.dart';
import '../../services/character/character_service.dart';
import '../../theme/colors.dart';

import '../../theme/padding.dart';
import '../../utils/constant.dart';
import '../../widget/play_youtube_video_widget.dart';

class SmartPenguatanKarakterTematik extends StatefulWidget {
  final String? idIdentitasSekolah;
  final String? idKategori;

  const SmartPenguatanKarakterTematik({Key? key, required this.idIdentitasSekolah, required this.idKategori}) : super(key: key);

  @override
  State<SmartPenguatanKarakterTematik> createState() => _SmartPenguatanKarakterTematikState();
}

class _SmartPenguatanKarakterTematikState extends State<SmartPenguatanKarakterTematik> {
  List VideoPembangunanKarakter = [];

  Future _getvideoPembangunanKarakterResource() async {
    var response = await CharacterService().getPenguatanKarakterTematik(widget.idIdentitasSekolah.toString(),widget.idKategori.toString());
    if (!mounted) return;
    setState(() {
      VideoPembangunanKarakter = response;
    });
  }

  Future refreshPenguatanKarakterTematik() async{
    _getvideoPembangunanKarakterResource();
  }

  @override
  void initState() {
    _getvideoPembangunanKarakterResource();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGrey,
      body: SafeArea(child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(padding),
        child: itemPenguatanKarakter(),
      )),
    );
  }

  Widget itemPenguatanKarakter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_rounded, size: 20,)),
            Padding(
              padding: EdgeInsets.only(left: padding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(titleSmartKarakter, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                  Visibility(
                    visible: true,
                    child: Text(
                      "Penguatan Karakter Tematik",
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16,),
        Expanded(
          child: Align(
              alignment: Alignment.center,
              child: ItemPenguatanKarakterTematik()
          ),
        ),
      ],
    );
  }

  Widget ItemPenguatanKarakterTematik() {
    return RefreshIndicator(
      onRefresh: refreshPenguatanKarakterTematik,
      color: kCelticBlue,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
            itemCount: VideoPembangunanKarakter.length,
            itemBuilder: (context, i) {
              String ytId = VideoPembangunanKarakter[i].video_url.substring(32, 43);
              DateTime dateTime =
              DateTime.parse(VideoPembangunanKarakter[i].created_at);
              String createdAt =
              DateFormat('dd/MM/yyyy hh:mm').format(dateTime);
              return GestureDetector(
                onTap: () { _CekDurasiPlayYoutube(VideoPembangunanKarakter[i].id.toString(), ytId);},
                child: Card(
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
                        padding: const EdgeInsets.only(bottom: 16.0, top: 10.0, left: 16.0, right: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${createdAt} - ${VideoPembangunanKarakter[i].category}"),
                            Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(VideoPembangunanKarakter[i].title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ))),
                            Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: VideoPembangunanKarakter[i].description != null
                                    ? Text("${VideoPembangunanKarakter[i].description}")
                                    : null
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  Future<void> _CekDurasiPlayYoutube(String id, String YtId) async{
    late EventClickModel _eventClickModel;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idSiswa = preferences.getInt('idSiswa').toString();
    String? idYoutube = preferences.getString('id_youtube_character_video');
    String? durasiPutarYoutube = preferences.getString('durasi_putar_youtube_character_video');
    if(idYoutube != null && durasiPutarYoutube != null) {
      var response = await CharacterService().DurationPlayPenguatanKarakter(
          idSiswa, idYoutube, durasiPutarYoutube);
      if(response != null && response != "Tidak ditemukan"){
        _eventClickModel = response;
        if (_eventClickModel.code == 200) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.remove("id_youtube_character_video");
          preferences.remove("durasi_putar_youtube_character_video");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PlayYoutubeVideoWidget(jenis: "character_video",id: id,
                      youtubeId: YtId)));
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("[Log Activity Error] Gagal terhubung ke server")));
        }
      }else if(response == "Tidak ditemukan"){
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.remove("id_youtube_character_video");
        preferences.remove("durasi_putar_youtube_character_video");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlayYoutubeVideoWidget(jenis: "character_video",id: id,
                    youtubeId: YtId)));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("[Log Activity Error] Gagal terhubung ke server")));
      }
    }else{
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PlayYoutubeVideoWidget(jenis: "character_video",id: id,
                  youtubeId: YtId)));
    }
  }
}