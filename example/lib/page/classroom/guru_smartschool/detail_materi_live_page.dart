import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:flutter_zoom_sdk_example/widget/video_player_widget_log.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/classroom/event_click_model.dart';
import '../../../services/classroom/event_click_service.dart';
import '../../../services/classroom/materi_live_service.dart';
import '../../../theme/colors.dart';
import '../../../theme/padding.dart';
import 'detail_materi_live/bahan_ajar_page.dart';
import 'detail_materi_live/bahan_tayang_page.dart';
import 'detail_materi_live/file_modul_page.dart';

// ignore: must_be_immutable
class DetailMateriLivePage extends StatefulWidget {
  final int id;
  final int sesiKe;
  final String judul;
  final String deskripsi;
  final String namaGuru;
  final String namaMataPelajaran;
  final String namaTingkat;
  final String tahunAkademik;
  final String namaTahunAkademik;
  String? urlFileModul;
  String? urlVideoBahan;
  String? bahanAjar;
  String? bahanTayang;
  String? tanggalTayang;
  DetailMateriLivePage(
      {Key? key,
      required this.id,
      required this.sesiKe,
      required this.judul,
      required this.deskripsi,
      required this.namaGuru,
      required this.namaMataPelajaran,
      required this.namaTingkat,
      required this.tahunAkademik,
      required this.namaTahunAkademik,
      required this.urlFileModul,
      required this.urlVideoBahan,
      required this.bahanAjar,
      required this.bahanTayang,
      required this.tanggalTayang})
      : super(key: key);

  @override
  State<DetailMateriLivePage> createState() => _DetailMateriLivePageState();
}

class _DetailMateriLivePageState extends State<DetailMateriLivePage> {
  late VlcPlayerController _videoPlayerController;
  late EventClickModel _eventClickModel;

  @override
  void initState() {
    _videoPlayerController = VlcPlayerController.network(
      '${widget.urlVideoBahan}',
      hwAcc: HwAcc.FULL,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(padding),
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerPage(),
              judulMateri(),
              detailDeskripsi(),
              fileModul(),
              bahanAjar(),
              bahanTayang(),
              bahanVideo(),
              detailGuru(),
            ],
          ),
        )),
      ),
    );
  }

  Widget backPage() {
    return IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back,
          size: 20,
        ));
  }

  Widget headerPage() {
    return Container(
      margin: const EdgeInsets.only(bottom: padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          backPage(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Pertemuan ke- ${widget.sesiKe}",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4,),
              Text("${widget.tanggalTayang}", style: const TextStyle(fontSize: 12),)
            ],
          )
        ],
      ),
    );
  }

  Widget fileModul() {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: padding),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(8), color: kGrey),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "File Modul",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          widget.urlFileModul == null
              ? const Padding(
                padding: EdgeInsets.only(right: padding),
                child: Text(
                    "-",
                    style: TextStyle(fontSize: 12),
                  ),
              )
              : TextButton(
                  onPressed: () => EventClickFile("file_modul"),
                  child: const Text(
                    "Lihat",
                    style: TextStyle(fontSize: 12),
                  ))
        ],
      ),
    );
  }

  Widget bahanAjar() {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: padding),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(8), color: kGrey),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Bahan Ajar",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          widget.bahanAjar == null
              ? const Padding(
                padding: EdgeInsets.only(right: padding),
                child: Text(
                    "-",
                    style: TextStyle(fontSize: 12),
                  ),
              )
              : TextButton(
                  onPressed: () => EventClickFile("bahan_ajar"),
                  child: const Text(
                    "Lihat",
                    style: TextStyle(fontSize: 12),
                  ))
        ],
      ),
    );
  }

  Widget bahanTayang() {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: padding),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(8), color: kGrey),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Bahan Tayang",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          widget.bahanTayang == null
              ? const Padding(
                padding: EdgeInsets.only(right: padding),
                child: Text(
                    "-",
                    style: TextStyle(fontSize: 12),
                  ),
              )
              : TextButton(
                  onPressed: () => EventClickFile("bahan_tayang"),
                  child: const Text(
                    "Lihat",
                    style: TextStyle(fontSize: 12),
                  ))
        ],
      ),
    );
  }

  Widget bahanVideo() {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: padding),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(8), color: kGrey),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Bahan Video",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          widget.urlVideoBahan == null
              ? const Padding(
                padding: EdgeInsets.only(right: padding),
                child: Text(
                    "-",
                    style: TextStyle(fontSize: 12),
                  ),
              )
              : TextButton(
                  onPressed: () => EventClickFile("video_bahan"),
                  child: const Text(
                    "Nonton",
                    style: TextStyle(fontSize: 12),
                  ))
        ],
      ),
    );
  }

  Future<void> EventClickFile(String data) async{
    var response = await EventClickService().eventClick(data,widget.id.toString());
    _eventClickModel = response;
    if(_eventClickModel.code == 200){
       if(data == "video_bahan"){
         _CekDurasiVideo();
       }else if(data == "bahan_tayang"){
         Navigator.push(
             context,
             MaterialPageRoute(
                 builder: (context) =>
                     BahanTayangPage(
                       bahanTayang: widget.bahanTayang.toString(),
                     )));
       }else if(data == "bahan_ajar"){
         Navigator.push(
             context,
             MaterialPageRoute(
                 builder: (context) => BahanAjarPage(
                   bahanAjar: widget.bahanAjar.toString(),
                 )));
       }else if(data == "file_modul"){
         Navigator.push(
             context,
             MaterialPageRoute(
                 builder: (context) => FileModulPage(
                   urlFileModul: widget.urlFileModul.toString(),
                 )));
       }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal terhubung keserver")));
    }
  }

  Future<void> _CekDurasiVideo() async{
    late EventClickModel _eventClickModel;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idVideo = preferences.getString('id_video_class_room_guruss');
    String? durasiPutar = preferences.getString('durasi_video_class_room_guruss');
    if(idVideo != null && durasiPutar != null) {
      var response = await MateriLiveService().DurationPlayVideo(idVideo, durasiPutar);
      if(response != null && response != "Tidak ditemukan"){
        _eventClickModel = response;
        if (_eventClickModel.code == 200) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.remove("id_video_class_room_guruss");
          preferences.remove("durasi_video_class_room_guruss");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      VideoPlayerLogWidget(id: widget.id.toString(), fileVideo: widget.urlVideoBahan)));
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("[Log Activity Error] Gagal terhubung ke server")));
        }
      }else if(response == "Tidak ditemukan"){
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.remove("id_video_class_room_guruss");
        preferences.remove("durasi_video_class_room_guruss");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    VideoPlayerLogWidget(id: widget.id.toString(),fileVideo: widget.urlVideoBahan)));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("[Log Activity Error] Gagal terhubung ke server")));
      }
    }else{
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  VideoPlayerLogWidget(id: widget.id.toString(),fileVideo: widget.urlVideoBahan)));
    }
  }

  Widget detailGuru() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: padding),
      padding: const EdgeInsets.all(8),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(8), color: kGrey),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Nama Guru",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              Flexible(
                child: Text(
                  " ${widget.namaGuru}",
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                      fontSize: 12,),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Nama Mata Pelajaran",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              Flexible(
                child: Text(
                  " ${widget.namaMataPelajaran}",
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                      fontSize: 12,),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tingkat",
                style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600
                ),
              ),
              Text(
                " ${widget.namaTingkat}",
                style:
                    const TextStyle(fontSize: 12),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tahun Akademik",
                style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600
                ),
              ),
              Text(
                " ${widget.namaTahunAkademik}",
                style:
                    const TextStyle(fontSize: 12),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }

  Widget judulMateri() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Text(
            "Judul Materi",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: padding),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: kGrey),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                " ${widget.judul}",
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget detailDeskripsi() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Text(
            "Deskripsi",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: padding),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: kGrey),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                " ${widget.deskripsi}",
                style: const TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
      ],
    );
  }
}
