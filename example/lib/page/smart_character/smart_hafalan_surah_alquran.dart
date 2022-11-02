import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../services/character/character_service.dart';
import '../../theme/colors.dart';
import '../../theme/padding.dart';
import '../../utils/constant.dart';

class SmartHafalanSurahAlquran extends StatefulWidget {
  final String? idSiswa;

  const SmartHafalanSurahAlquran({Key? key, required this.idSiswa}) : super(key: key);

  @override
  State<SmartHafalanSurahAlquran> createState() => _SmartHafalanSurahAlquranState();
}

class _SmartHafalanSurahAlquranState extends State<SmartHafalanSurahAlquran> {
  List Hafalanlist = [];
  bool isLoading = true;
  bool cekKoneksi = true;

  Future _gethafalanResource() async {
    setState(() {
      cekKoneksi = true;
      isLoading = true;
    });
    var response = await CharacterService().getDataHafalanSurahQuran(widget.idSiswa.toString());
    if(response != null){
      if (!mounted) return;
      setState(() {
        Hafalanlist = response;
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

  Future refresh() async {
    await _gethafalanResource();
  }

  @override
  void initState() {
    _gethafalanResource();
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
                      "Hafalan Surah Al-Qur'an",
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
              child: itemHafalanList()
          ),
        ),
      ],
    );
  }

  Widget itemHafalanList() {
    return RefreshIndicator(
        onRefresh: refresh,
        color: kCelticBlue,
        child: cekKoneksi == true
            ? isLoading == true
              ? Center(child: CircularProgressIndicator(),)
              : Hafalanlist.length == 0
                ? buildNoData()
                : ListView.builder(
                itemCount: Hafalanlist.length,
                itemBuilder: (context, i) {
                  DateTime dateTime =
                  DateTime.parse(Hafalanlist[i].created_at);
                  String createdAt =
                  DateFormat('dd/MM/yyyy hh:mm').format(dateTime);
                  return Card(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 2.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Surah ${Hafalanlist[i].nama_surah}',
                                        style: const TextStyle(fontWeight: FontWeight.w600,),
                                      ),
                                    ),
                                    Spacer(),
                                    Align(
                                      child: Text(
                                        createdAt,
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Ayat ${Hafalanlist[i].nomor_ayat_dari} sampai ${Hafalanlist[i].nomor_ayat_sampai}',
                                    style: TextStyle(color: Colors.black.withOpacity(0.5),),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(top:8.0, bottom: 8.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Makhraj : ${Hafalanlist[i].makhraj},\nTajwid : ${Hafalanlist[i].tajwid},\nPelafalan : ${Hafalanlist[i].pelafalan}',
                                              style: TextStyle(color: Colors.black.withOpacity(0.6),),
                                            ),
                                          ],
                                        )
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 2.0, bottom: 16.0),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Keterangan',
                                    style: TextStyle(color: Colors.black.withOpacity(0.5),),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Hafalanlist[i].keterangan != null
                                      ? Text(
                                    '${Hafalanlist[i].keterangan}',
                                    style: TextStyle(color: Colors.black.withOpacity(0.6),),
                                  )
                                      : Text(
                                    '-',
                                    style: TextStyle(color: Colors.black.withOpacity(0.6),),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
              onPressed: refresh,
              child: Text(
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
                onPressed: refresh,
                child: Text(
                  "Refresh",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ])
    );
  }
}