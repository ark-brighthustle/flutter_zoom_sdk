import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_sdk_example/theme/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/classroom/materi_live_service.dart';
import '../../../theme/padding.dart';
import 'detail_materi_live_page.dart';

class MateriLivePage extends StatefulWidget {
  final int id;
  final String kodeTingkat;
  final String namaMataPelajaran;
  const MateriLivePage(
      {Key? key,
      required this.id,
      required this.kodeTingkat,
      required this.namaMataPelajaran})
      : super(key: key);

  @override
  State<MateriLivePage> createState() => _MateriLivePageState();
}

class _MateriLivePageState extends State<MateriLivePage> {
  List _materiLiveList = [];
  String? tingkat;
  bool isLoading = true;

  Future getDataMateriLive() async {
    setState(() {
      isLoading = true;
    });
    var response = await MateriLiveService().getDataMateriLive(widget.id.toString());
    if (!mounted) return;
    setState(() {
      _materiLiveList = response;
      isLoading = false;
    });
  }

  getSiswa() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      tingkat = preferences.getString("tingkat");
    }); 
  }

  @override
  void initState() {
    getDataMateriLive();
    getSiswa();
    super.initState();
  }

  Future onRefresh() async{
    await getDataMateriLive();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: padding),
          child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, size: 20,)),
        ),
        title: Text(
          widget.namaMataPelajaran,
          style: const TextStyle(fontSize: 12),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: materiLive(),
      ),
    );
  }

  Widget materiLive() {
    return Expanded(
        child: RefreshIndicator(
            onRefresh: onRefresh,
            color: kCelticBlue,
            child: isLoading == true
                ? Center(child: CircularProgressIndicator())
                : Stack(
              children: [
                ListView.builder(
                    itemCount: _materiLiveList.length,
                    itemBuilder: (context, i) {
                      if (tingkat.toString() == widget.kodeTingkat && widget.id == _materiLiveList[i].pelajaranId) {
                        return Column(
                          children: [
                            ListTile(
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailMateriLivePage(
                                id: _materiLiveList[i].id,
                                sesiKe: _materiLiveList[i].sesiKe,
                                judul: _materiLiveList[i].judul,
                                deskripsi: _materiLiveList[i].deskripsi,
                                namaGuru: _materiLiveList[i].namaGuruSmart,
                                namaMataPelajaran: _materiLiveList[i].namaMataPelajaran,
                                namaTingkat: _materiLiveList[i].namaTingkat,
                                tahunAkademik: _materiLiveList[i].tahunAkademik,
                                namaTahunAkademik: _materiLiveList[i].namaTahunAkademik,
                                urlFileModul: _materiLiveList[i].urlFileModul,
                                urlVideoBahan: _materiLiveList[i].urlVideoBahan,
                                bahanAjar: _materiLiveList[i].bahanAjar,
                                bahanTayang: _materiLiveList[i].bahanTayang,
                                tanggalTayang: _materiLiveList[i].tanggalTayang,
                              ))),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Pertemuan ke- ${_materiLiveList[i].sesiKe}",
                                    style: const TextStyle(
                                        fontSize: 12, fontWeight: FontWeight.w600),
                                  ),

                                ],
                              ),
                              subtitle: Text(
                                "${_materiLiveList[i].judul}",
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                              trailing:  Text("${_materiLiveList[i].tanggalTayang}", style: const TextStyle(fontSize: 12),),
                            ),
                            const Divider(thickness: 1,)
                          ],
                        );
                      }

                      return Container();
                    }),
                buildNoData()
              ],
            )
        )
    );
  }

  Widget buildNoData() {
    if (_materiLiveList.length == 0) {
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
              )
            ]),
      );
    }else{
      return Container();
    }
  }
}
