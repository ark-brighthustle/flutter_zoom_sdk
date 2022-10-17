import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_zoom_sdk_example/page/classroom/guru_pendamping/elearning_page.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../helpers/helpers.dart';
import '../../models/classroom/event_click_model.dart';
import '../../services/classroom/category_elearning_service.dart';
import '../../services/classroom/mapel_service.dart';
import '../../services/classroom/materi_live_service.dart';
import '../../services/jadwal_siswa/jadwal_siswa_service.dart';
import '../../theme/colors.dart';
import '../../theme/material_colors.dart';
import '../../theme/padding.dart';
import '../../utils/config.dart';
import '../../utils/constant.dart';
import 'guru_smartschool/materi_live_page.dart';

class ClassRoomPage extends StatefulWidget {
  const ClassRoomPage({Key? key}) : super(key: key);

  @override
  State<ClassRoomPage> createState() => _ClassRoomPageState();
}

class _ClassRoomPageState extends State<ClassRoomPage> with TickerProviderStateMixin {
  String? token;
  List listElearning = [];
  List listMapel = [];
  List listJadwalSiswa = [];
  late final TabController _tabController = TabController(length: 2, vsync: this);

  getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString("access_token");
    });
  }

   Future getDataMapel() async {
    var response = await MapelService().getDataMapel();
    if (!mounted) return;
    setState(() {
      listMapel = response;
    });
  }

  Future getJadwalSiswa() async {
    var response = await JadwalSiswaService().getDataJadwalSiswa();
    if (!mounted) return;
    setState(() {
      listJadwalSiswa = response;
    });
  }

  Future refreshGuruSmartSchool() async {
    await MapelService().getDataMapel();
  }

  Future refreshGuruPendamping() async {
    await JadwalSiswaService().getDataJadwalSiswa();
  }

  getLogActivity() async {
    String token = await Helpers().getToken() ?? "";
    var url = Uri.parse("$API_V2/siswa_log/materi_live");
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
    getToken();
    getDataMapel();
    getJadwalSiswa();
    PlayVideo();
    Future.delayed(const Duration(seconds: 1), () {
      getLogActivity();
    });
    super.initState();
  }

  PlayVideo() async{
    bool playVideo = await _CekDurasiVideo();
    if(playVideo == true){
      getDataMapel();
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("[Log Activity Error] Gagal terhubung ke server")));
    }
  }

  Future<bool> _CekDurasiVideo() async{
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
          return true;
        }else{
          return false;
        }
      }else if(response == "Tidak ditemukan"){
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.remove("id_video_class_room_guruss");
        preferences.remove("durasi_video_class_room_guruss");
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
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(titleAppBarClassRoom, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
            automaticallyImplyLeading: false,
            bottom: const PreferredSize(
              preferredSize: Size(120, 40),
              child: SizedBox(
                child: TabBar(
                  indicatorColor: kWhite, 
                  labelColor: kWhite,
                  tabs: [
                  SizedBox(
                    height: 48,
                    child: Tab(
                      text: 'Guru SmartSchool', 
                    ),
                  ),
                  SizedBox(
                    height: 48,
                    child: Tab(
                      text: 'Guru Pendamping',
                    ),
                  )
                ]),
              ),
            ),
          ),
          body: TabBarView(children: <Widget>[guruSmartSchool(), guruPendamping()]),
        ));
  }

  Widget guruSmartSchool() {
    return RefreshIndicator(
      onRefresh: refreshGuruSmartSchool,
      color: kCelticBlue,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView.builder(
          itemCount: listMapel.length,
          itemBuilder: (context, i){
          return Column(
            children: [
              ListTile(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MateriLivePage(
                  id: listMapel[i].id,
                  kodeTingkat: listMapel[i].kodeTingkat,
                  namaMataPelajaran: listMapel[i].namaPelajaran 
                ))),
                leading: Image.asset("assets/icon/book.png", width: 24,),
                title: Text("${listMapel[i].namaPelajaran}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
                trailing: const Icon(Icons.arrow_forward_ios, size: 12,),
              ),
              const Divider(thickness: 1,)
            ],
          );
        }),
      ),
    );
  }

  Widget guruPendamping() { 
    return RefreshIndicator(
      onRefresh: refreshGuruPendamping,
      color: kCelticBlue,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: ListView.builder(
              itemCount: listJadwalSiswa.length,
              itemBuilder: (context, i) {
                String jamMulai = listJadwalSiswa[i].jamMulai.substring(0, 5);
                String jamSelesai = listJadwalSiswa[i].jamSelesai.substring(0, 5);

                if (listJadwalSiswa[i].hari == "Senin") {
                  return GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ElearningPage(
                      kodeJadwal: listJadwalSiswa[i].kodejdwl, 
                      hari: listJadwalSiswa[i].hari,
                      jamKe: listJadwalSiswa[i].jamKe,
                      mapel: listJadwalSiswa[i].namaMataPelajaran,
                      jamMulai: jamMulai,
                      jamSelesai: jamSelesai))),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: kGreen.withOpacity(0.3)
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              "${listJadwalSiswa[i].hari}",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
                            ),
                          ),
                         Text("Jam Ke- ${listJadwalSiswa[i].jamKe}", style: const TextStyle(fontSize: 12,),),
                          const Divider(thickness: 1,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  "${listJadwalSiswa[i].namaMataPelajaran}",
                                  style:
                                      const TextStyle(fontSize: 12, fontWeight: FontWeight.w600,), 
                                      textAlign: TextAlign.start,
                                ),
                              ),
                              Text(
                                "$jamMulai - $jamSelesai WITA",
                                style:
                                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w500,),
                              ),
                              
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (listJadwalSiswa[i].hari == "Selasa") {
                  return GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ElearningPage(
                      kodeJadwal: listJadwalSiswa[i].kodejdwl, 
                      hari: listJadwalSiswa[i].hari,
                      jamKe: listJadwalSiswa[i].jamKe,
                      mapel: listJadwalSiswa[i].namaMataPelajaran,
                      jamMulai: jamMulai,
                      jamSelesai: jamSelesai))),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: kRed.withOpacity(0.3)
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              "${listJadwalSiswa[i].hari}",
                              style: const TextStyle( fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                         Text("Jam Ke- ${listJadwalSiswa[i].jamKe}", style: const TextStyle(fontSize: 12),),
                          const Divider(thickness: 1,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  "${listJadwalSiswa[i].namaMataPelajaran}",
                                  style:
                                      const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.start,
                                ),
                              ),
                              Text(
                                "$jamMulai - $jamSelesai WITA",
                                style:
                                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (listJadwalSiswa[i].hari == "Rabu") {
                  return GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ElearningPage(
                      kodeJadwal: listJadwalSiswa[i].kodejdwl, 
                      hari: listJadwalSiswa[i].hari,
                      jamKe: listJadwalSiswa[i].jamKe,
                      mapel: listJadwalSiswa[i].namaMataPelajaran,
                      jamMulai: jamMulai,
                      jamSelesai: jamSelesai))),
                    child: Container(
                       padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: kYellow.withOpacity(0.3)
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              "${listJadwalSiswa[i].hari}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text("Jam Ke- ${listJadwalSiswa[i].jamKe}", style: const TextStyle(fontSize: 12),),
                          const Divider(thickness: 1,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                               Flexible(
                                child: Text(
                                  "${listJadwalSiswa[i].namaMataPelajaran}",
                                  style:
                                      const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.start,
                                ),
                              ),
                              Text(
                                "$jamMulai - $jamSelesai WITA",
                                style:
                                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                             
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (listJadwalSiswa[i].hari == "Kamis") {
                  return GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ElearningPage(
                      kodeJadwal: listJadwalSiswa[i].kodejdwl, 
                      hari: listJadwalSiswa[i].hari,
                      jamKe: listJadwalSiswa[i].jamKe,
                      mapel: listJadwalSiswa[i].namaMataPelajaran,
                      jamMulai: jamMulai,
                      jamSelesai: jamSelesai))),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: kCelticBlue.withOpacity(0.3)
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              "${listJadwalSiswa[i].hari}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text("Jam Ke- ${listJadwalSiswa[i].jamKe}", style: const TextStyle(fontSize: 12),),
                          const Divider(thickness: 1,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  "${listJadwalSiswa[i].namaMataPelajaran}",
                                  style:
                                      const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Text(
                                "$jamMulai - $jamSelesai WITA",
                                style:
                                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (listJadwalSiswa[i].hari == "Jumat") {
                  return GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ElearningPage(
                      kodeJadwal: listJadwalSiswa[i].kodejdwl, 
                      hari: listJadwalSiswa[i].hari,
                      jamKe: listJadwalSiswa[i].jamKe,
                      mapel: listJadwalSiswa[i].namaMataPelajaran,
                      jamMulai: jamMulai,
                      jamSelesai: jamSelesai))),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: kOrange.withOpacity(0.3)
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              "${listJadwalSiswa[i].hari}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                         Text("Jam Ke- ${listJadwalSiswa[i].jamKe}", style: const TextStyle(fontSize: 12),),
                          const Divider(thickness: 1,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  "${listJadwalSiswa[i].namaMataPelajaran}",
                                  style:
                                      const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.start,
                                ),
                              ),
                              Text(
                                "$jamMulai - $jamSelesai WITA",
                                style:
                                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return const Text("Jadwal Tidak Ditemukan");
              }),
      ),
    );
  }

  /*Widget guruPendamping() { 
    return RefreshIndicator(
      onRefresh: refreshGuruPendamping,
      color: kCelticBlue,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: padding, vertical: 8),
        child: GridView.builder(
            itemCount: listElearning.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 2.1, crossAxisCount: 1),
            itemBuilder: (context, i) {
              String idLink = listElearning[i].image.substring(32, 65);
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (listElearning[i].id == 1) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => BahanElearningPage(id: listElearning[i].id, namaKategori: listElearning[i].namaKategori)));
                      } else if (listElearning[i].id == 2) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TugasElearningPage(id: listElearning[i].id, namaKategori: listElearning[i].namaKategori)));
                      } else if (listElearning[i].id == 3) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UjianElearningPage(id: listElearning[i].id, namaKategori: listElearning[i].namaKategori)));
                      }
                    },
                    child: SizedBox(
                      child: Image.network(
                        "https://drive.google.com/uc?export=download&id=$idLink",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            alignment: Alignment.center,
                            child: const Text(
                              "Gagal Memuat Gambar!",
                              style: TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }*/
}