import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../helpers/helpers.dart';
import '../../models/classroom/event_click_model.dart';
import '../../services/banner/banner_service.dart';
import '../../services/learning_resources/bank_soal_service.dart';
import '../../services/learning_resources/learning_resource_service.dart';
import '../../theme/colors.dart';
import '../../theme/material_colors.dart';
import '../../theme/padding.dart';
import '../../utils/config.dart';

import '../../utils/constant.dart';
import 'bank_soal/bank_soal_mapel_page.dart';
import 'membaca/membaca_page.dart';
import 'menonton/menonton_page.dart';

class LearningResourcePage extends StatefulWidget {
  const LearningResourcePage({Key? key}) : super(key: key);

  @override
  State<LearningResourcePage> createState() => _LearningResourcePageState();
}

class _LearningResourcePageState extends State<LearningResourcePage> {
  List bannerGubList = [];

  Future getBannerGubList() async {
    var bannerService = BannerService();
    var response = await bannerService.getDataBannerGub();
    if (!mounted) return;
    setState(() {
      bannerGubList = response;
    });
  }

  getLogActivity() async {
    String token = await Helpers().getToken() ?? "";
    var url = Uri.parse("$API_V2/siswa_log/video_learning_resource");
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
    durasiPlayMenontonYoutube();
    Future.delayed(const Duration(seconds: 1), () {
      getLogActivity();
    });
    super.initState();
  }

  durasiPlayMenontonYoutube() async{
    bool playYoutube = await _CekDurasiPlayMenontonYoutube();
    bool playVideo = await _CekDurasiVideo();
    if(playYoutube == true && playVideo == true){
      getBannerGubList();
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("[Log Activity Error] Gagal terhubung ke server")));
    }
  }

  Future<bool> _CekDurasiPlayMenontonYoutube() async{
    late EventClickModel _eventClickModel;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idSiswa = preferences.getInt('idSiswa').toString();
    String? idYoutube = preferences.getString('id_youtube_learning_resource');
    String? durasiPutarYoutube = preferences.getString('durasi_putar_youtube_learning_resource');
    if(idYoutube != null && durasiPutarYoutube != null) {
      var response = await LearningResourceService().DurationPlayLearningResouce(
          idSiswa, idYoutube, durasiPutarYoutube);
      if(response != null && response != "Tidak ditemukan"){
        _eventClickModel = response;
        if (_eventClickModel.code == 200) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.remove("id_youtube_learning_resource");
          preferences.remove("durasi_putar_youtube_learning_resource");
          return true;
        }else{
          return false;
        }
      }else if(response == "Tidak ditemukan"){
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.remove("id_youtube_learning_resource");
        preferences.remove("durasi_putar_youtube_learning_resource");
        return true;
      }else{
        return false;
      }
    }else{
      return true;
    }
  }

  Future<bool> _CekDurasiVideo() async{
    late EventClickModel _eventClickModel;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? idSiswa = preferences.getInt('idSiswa').toString();
    String? idVideo = preferences.getString('id_video_bank_soal');
    String? durasiPutar = preferences.getString('durasi_video_bank_soal');
    if(idVideo != null && durasiPutar != null) {
      var response = await BankSoalService().DurationPlayVideoBankSoal(idSiswa, idVideo, durasiPutar);
      if(response != null && response != "Tidak ditemukan") {
        _eventClickModel = response;
        if (_eventClickModel.code == 200) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.remove("id_video_bank_soal");
          preferences.remove("durasi_video_bank_soal");
          return true;
        } else {
          return false;
        }
      }else if(response == "Tidak ditemukan"){
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.remove("id_video_bank_soal");
        preferences.remove("durasi_video_bank_soal");
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
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              iconButtonBack(),
              titleTopikMapel(),
              topikMembaca(),
              topikMenonton(),
              topikBankSoal(),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconButtonBack() {
    return IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, size: 20,));
  }

  Widget titleTopikMapel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Padding(
          padding: EdgeInsets.all(padding),
          child: Text(titleAppBarLearningResources, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        ),
        Padding(
          padding: EdgeInsets.all(padding),
          child: Text(
            "Yuk, Dipilih dulu mau membaca, menonton atau melihat bank soal",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget topikMembaca() {
    String title = "Membaca";
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(padding),
      padding: const EdgeInsets.all(8),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(8), color: kWhite),
      child: ListTile(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => MembacaPage(title: title))),
        leading: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Image.asset("assets/icon/membaca.png"),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
      ),
    );
  }

  Widget topikMenonton() {
    String title = "Menonton";
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(padding),
      padding: const EdgeInsets.all(8),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(8), color: kWhite),
      child: ListTile(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => MenontonPage(title: title))),
        leading: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Image.asset("assets/icon/menonton.png"),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
      ),
    );
  }

  Widget topikBankSoal() {
    String title = "Bank Soal";
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(padding),
      padding: const EdgeInsets.all(8),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(8), color: kWhite),
      child: ListTile(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => BankSoalMapelPage(title: title))),
        leading: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Image.asset("assets/icon/bank_soal.png"),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
      ),
    );
  }
}
