import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

import '../../helpers/helpers.dart';
import '../../services/classroom/mapel_service.dart';
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

  Future getDataMapel() async {
    var response = await MapelService().getDataMapel();
    if (!mounted) return;
    setState(() {
      mapelList = response;
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
    //durasiPlayYoutube();
    Future.delayed(const Duration(seconds: 1), () {
      getLogActivity();
    });
  }

  /*durasiPlayYoutube() async{
    bool playYoutube = await _CekDurasiPlayYoutube();
    if(playYoutube == true){
      //getDataMapel();
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("[Log Activity Error] Gagal terhubung ke server")));
    }
  }*/

  /*Future<bool> _CekDurasiPlayYoutube() async{
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
  }*/

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
          child: ListView.builder(
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
              }),
        ));
  }
}
