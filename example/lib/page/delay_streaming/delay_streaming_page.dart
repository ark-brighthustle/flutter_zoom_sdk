import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/helpers.dart';
import '../../models/classroom/event_click_model.dart';
import '../../services/classroom/mapel_service.dart';
import '../../services/delay_streaming/delay_streaming_service.dart';
import '../../theme/colors.dart';
import '../../theme/material_colors.dart';
import '../../utils/config.dart';
import '../../utils/constant.dart';
import 'detail_delay_streaming_page.dart';

class DelayStreamingPage extends StatefulWidget {
  const DelayStreamingPage({Key? key}) : super(key: key);

  @override
  _DelayStreamingPageState createState() => _DelayStreamingPageState();
}

class _DelayStreamingPageState extends State<DelayStreamingPage>
    with TickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  List mapelList = [];
  bool isLoading = true;
  bool cekKoneksi = true;

  Future getDataMapel() async {
    setState(() {
      cekKoneksi = true;
      isLoading = true;
    });
    var response = await MapelService().getDataMapel();
    if(response != null){
      if (!mounted) return;
      setState(() {
        mapelList = response;
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
    await durasiPlayYoutube();
    await getDataMapel();
    Future.delayed(const Duration(seconds: 1), () {
      getLogActivity();
    });
  }

  getLogActivity() async {
    String token = await Helpers().getToken() ?? "";
    var url = Uri.parse("$API_V2/siswa_log/delay_stream");
    final response = await http.get(url, headers: {'Authorization': 'Bearer $token'});
    var responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var message = responseJson['message'];
      print(message);
    } else if (response.statusCode == 400) {
      var message = responseJson['message'];
      alertMessage(message);
    } else {
      return throw Exception("failed to load");
    }
  }

  alertMessage(String message) {
    QuickAlert.show(
      context: context, 
      type: QuickAlertType.info,
      title: 'Info',
      text: 'Halo, Anda $message ',
      confirmBtnColor: colorCelticBlue,
      );
  }

  @override
  void initState() {
    super.initState();
    getDataMapel();
    durasiPlayYoutube();
    Future.delayed(const Duration(seconds: 1), () {
      getLogActivity();
    });
  }

  durasiPlayYoutube() async{
    bool playYoutube = await cekDurasiPlayYoutube();
    if(playYoutube != true){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("[Log Activity Error] Gagal terhubung ke server")));
    }
  }

  Future<bool> cekDurasiPlayYoutube() async{
    late EventClickModel _eventClickModel;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idSiswa = preferences.getInt('idSiswa').toString();
    String? idYoutube = preferences.getString('id_youtube_delay_streaming');
    String? durasiPutarYoutube = preferences.getString('durasi_putar_youtube_delay_streaming');
    if(idYoutube != null && durasiPutarYoutube != null) {
      var response = await DelayStreamingService().durationPlay(
          idSiswa, idYoutube, durasiPutarYoutube);
      if(response != null && response != "Tidak ditemukan"){
        _eventClickModel = response;
        if (_eventClickModel.code == 200) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.remove("id_youtube_delay_streaming");
          preferences.remove("durasi_putar_youtube_delay_streaming");
          return true;
        }else{
          return false;
        }
      }else if(response == "Tidak ditemukan"){
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.remove("id_youtube_delay_streaming");
        preferences.remove("durasi_putar_youtube_delay_streaming");
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text(
            titleAppBarDelayStream,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: kWhite),
          ),
        ),
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: buildMapel()
        ));
  }

  Widget buildMapel() {
    return RefreshIndicator(
        onRefresh: onRefresh,
        color: kCelticBlue,
        child: cekKoneksi == true
           ? isLoading == true
            ? const Center(child: CircularProgressIndicator())
            : mapelList.isEmpty
              ? buildNoData()
              : ListView.builder(
            itemCount: mapelList.length,
            itemBuilder: (context, i) {
              return Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8), color: kGrey),
                child: ListTile(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailDelayStreamingPage(
                              namaMapel: mapelList[i].namaPelajaran,
                              kodeMapel: mapelList[i].kode))),
                  leading: Image.asset('assets/icon/delay_streaming.png'),
                  title: Text(
                    "${mapelList[i].namaPelajaran}",
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  trailing: const Icon(Icons.arrow_circle_right_rounded, color: kCelticBlue, size: 20,),
                ),
              );
            })
            : buildNoKoneksi()
    );
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
