
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/classroom/event_click_model.dart';
import '../../services/character/character_service.dart';
import '../../theme/colors.dart';
import '../../theme/padding.dart';
import '../../utils/constant.dart';
import 'smart_penguatan_karakter_tematik.dart';

class SmartKategoriPenguatanKarakterTematik extends StatefulWidget {
  final String? idIdentitasSekolah;

  const SmartKategoriPenguatanKarakterTematik({Key? key, required this.idIdentitasSekolah}) : super(key: key);

  @override
  State<SmartKategoriPenguatanKarakterTematik> createState() => _SmartKategoriPenguatanKarakterTematikState();
}

class _SmartKategoriPenguatanKarakterTematikState extends State<SmartKategoriPenguatanKarakterTematik> {
  List KategoriPenguatanKarakterTematik = [];

  Future _getKategoriPenguatanKarakterTemaikResource() async {
    var response = await CharacterService().getKategoriPenguatanKarakterTematik();
    if (!mounted) return;
    setState(() {
      KategoriPenguatanKarakterTematik = response;
    });
  }

  Future refreshKategori() async {
    _getKategoriPenguatanKarakterTemaikResource();
  }

  @override
  void initState() {
    durasiPlayYoutube();
    super.initState();
  }

  durasiPlayYoutube() async{
    bool playYoutube = await _CekDurasiPlayYoutube();
    if(playYoutube == true){
      _getKategoriPenguatanKarakterTemaikResource();
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("[Log Activity Error] Gagal terhubung ke server")));
    }
  }

  Future<bool> _CekDurasiPlayYoutube() async{
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
          return true;
        }else{
          return false;
        }
      }else if(response == "Tidak ditemukan"){
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.remove("id_youtube_character_video");
        preferences.remove("durasi_putar_youtube_character_video");
        return true;
      }else{
        return false;
      }
    }else{
     return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGrey,
      body: SafeArea(child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(padding),
        child: itemHafalanAlQuran(),
      )),
    );
  }

  Widget itemHafalanAlQuran() {
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
                      "Kategori Penguatan Karakter Tematik",
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
              child: ItemKategori()
          ),
        ),
      ],
    );
  }

  Widget ItemKategori() {
    return RefreshIndicator(
      onRefresh: refreshKategori,
      color: kCelticBlue,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
            itemCount: KategoriPenguatanKarakterTematik.length,
            itemBuilder: (context, i){
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: kWhite
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ListTile(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SmartPenguatanKarakterTematik(
                      idIdentitasSekolah: widget.idIdentitasSekolah, idKategori: KategoriPenguatanKarakterTematik[i].id.toString(),
                    ))),
                    title: Text("${KategoriPenguatanKarakterTematik[i].name}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
                    subtitle: Text("${KategoriPenguatanKarakterTematik[i].description}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16,),
                  ),
                ),
              );
            }),
      ),
    );
  }
}