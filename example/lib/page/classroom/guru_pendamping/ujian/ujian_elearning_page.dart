import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_sdk_example/page/classroom/guru_pendamping/ujian/hasil_ujian_elearning_page.dart';
import 'package:flutter_zoom_sdk_example/theme/padding.dart';
import 'package:intl/intl.dart';

import '../../../../services/classroom/elearning_service.dart';
import '../../../../theme/colors.dart';
import 'soal_ujian_elearning.dart';

class UjianElearningPage extends StatefulWidget {
  final int kodeJadwal;
  final int id;
  final String namaKategori;
  const UjianElearningPage({Key? key, required this.id, required this.namaKategori, required this.kodeJadwal}) : super(key: key);

  @override
  State<UjianElearningPage> createState() => _UjianElearningPageState();
}

class _UjianElearningPageState extends State<UjianElearningPage> {
  final DateTime _dateTimeNow = DateTime.now();

  List listUjianElearning = [];
  bool isLoading = true;
  bool cekKoneksi = true;

  Future getUjianElearning() async {
    setState(() {
      cekKoneksi = true;
      isLoading = true;
    });
    var response = await ElearningService().getDataElearningUjian(widget.kodeJadwal);
    if(response != null){
      if (!mounted) return;
      setState(() {
        listUjianElearning = response;
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

  @override
  void initState() {
    getUjianElearning();
    super.initState();
  }

  Future onRefresh() async{
    await getUjianElearning();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(),
              buildItemUjianElearning(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: kCelticBlue, size: 20,)),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(widget.namaKategori, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
          ),
        ],
      ),
    );
  }

  Widget buildItemUjianElearning() {
    return Expanded(
        child: RefreshIndicator(
            onRefresh: onRefresh,
            color: kCelticBlue,
            child: cekKoneksi == true
                ? isLoading == true
                    ? Center(child: CircularProgressIndicator())
                    : listUjianElearning.length == 0
                        ? buildNoData()
                        : ListView.builder(
                        itemCount: listUjianElearning.length,
                        itemBuilder: (context, i){
                          DateTime dateTimeMulai = DateTime.parse(listUjianElearning[i].waktuMulai);
                          String waktuMulai = DateFormat('dd-MM-yyyy HH:mm').format(dateTimeMulai);
                          DateTime dateTimeSelesai = DateTime.parse(listUjianElearning[i].waktuSelesai);
                          String waktuSelesai = DateFormat('dd-MM-yyyy HH:mm').format(dateTimeSelesai);
                          return SizedBox(
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    if(listUjianElearning[i].statusWaktu == "Belum Dimulai"){
                                      alertDialogisBefore(waktuMulai);
                                    }else if(listUjianElearning[i].statusWaktu == "Sementara Berlangsung"){
                                      if(listUjianElearning[i].statusKerjakan == true){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => HasilUjianElearningPage(
                                          detailHasilUjian: false,
                                          id: listUjianElearning[i].id,
                                          judul: listUjianElearning[i].judul,
                                        )));
                                      }else{
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => SoalUjianElearningPage(
                                          id: listUjianElearning[i].id,
                                          judul: listUjianElearning[i].judul,
                                          waktuMulai: listUjianElearning[i].waktuMulai,
                                          waktuSelesai: listUjianElearning[i].waktuSelesai,
                                        )));
                                      }
                                    }else if(listUjianElearning[i].statusWaktu == "Ujian Selesai"){
                                      alertDialogisAfter(waktuSelesai, listUjianElearning[i].id, listUjianElearning[i].judul);
                                    }
                                    /*if (_dateTimeNow.isBefore(DateTime.parse(listUjianElearning[i].waktuMulai))) {
                                  alertDialogisBefore(listUjianElearning[i].waktuMulai);
                                } else if (_dateTimeNow.isAfter(DateTime.parse(listUjianElearning[i].waktuSelesai))) {
                                  alertDialogisAfter(listUjianElearning[i].waktuSelesai);
                                } else {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SoalUjianElearningPage(
                                    id: listUjianElearning[i].id,
                                    elearningCategoryId: listUjianElearning[i].elearningCategoryId,
                                    namaKategori: listUjianElearning[i].namaKategori,
                                    idMataPelajaran: listUjianElearning[i].idMataPelajaran,
                                    namaMataPelajaran: listUjianElearning[i].namaMataPelajaran,
                                    judul: listUjianElearning[i].judul,
                                    deskripsi: listUjianElearning[i].deskripsi,
                                    fileUrl: listUjianElearning[i].fileUrl,
                                    videoUrl: listUjianElearning[i].videoUrl,
                                    waktuMulai: listUjianElearning[i].waktuMulai,
                                    waktuSelesai: listUjianElearning[i].waktuSelesai,
                                    createdAt: listUjianElearning[i].createdAt,
                                    updatedAt: listUjianElearning[i].updatedAt
                                  )));
                                }*/
                                  },
                                  leading: Image.asset("assets/icon/quiz.png", width: 40,),
                                  title: Text("${listUjianElearning[i].namaMataPelajaran}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
                                  subtitle: Text("${waktuMulai} - ${waktuSelesai}\n${listUjianElearning[i].judul}", style: const TextStyle(fontSize: 12),),
                                  trailing: const Icon(Icons.arrow_forward_ios, size: 12,),
                                ),
                                const Divider(thickness: 1,)
                              ],

                            ),
                          );
                        })
                : buildNoKoneksi()
        )
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
              child: Text(
                "Refresh",
                style: TextStyle(color: Colors.white),
              ),
            )
          ]),
    );
  }

  alertDialogisBefore(String waktuMulai) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.dangerous, size: 72, color: Colors.red),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  'Etss, Waktu Ujian/Quiz belum dimulai',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 4,
                ),
                const SizedBox(height: 12,),
                const Text(
                    'Waktu Ujian/Quiz',
                    style: TextStyle(fontSize: 12)),
                const SizedBox(height: 4,),
                Text(
                    '$waktuMulai',
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Center(child: Text('OK')))
            ],
          );
        });
  }

  alertDialogisAfter(String waktuSelesai, int id, String judul) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.dangerous, size: 72, color: Colors.red),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  'Maaf yaa, Waktu Ujian/Quiz telah berakhir!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 4,
                ),
                const SizedBox(height: 12,),
                const Text(
                    'Batas Waktu Ujian/Quiz',
                    style: TextStyle(fontSize: 12)),
                const SizedBox(
                  height: 4,
                ),
                Text(
                    '$waktuSelesai',
                    style: const TextStyle(fontSize: 12)),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => {
                    Navigator.pop(context),
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HasilUjianElearningPage(
                      detailHasilUjian: true,
                      id: id,
                      judul: judul,
                    )))
                  },
                  child: const Center(child: Text('OK')))
            ],
          );
        });
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
                child: Text(
                  "Refresh",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ])
    );
  }
}