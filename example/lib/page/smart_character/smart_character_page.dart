import 'package:flutter/material.dart';

import '../../utils/constant.dart';
import 'smart_amaliah_page.dart';
import 'smart_baca_tulis_alquran.dart';
import 'smart_fiqi_hadist_page.dart';
import '../../theme/colors.dart';
import 'smart_hafalan_surah_alquran.dart';
import 'smart_kategori_penguatan_karakter_tematik.dart';

class SmartCharacterPage extends StatefulWidget {
  final String idSiswa;
  final String idIdentitasSekolah;

  const SmartCharacterPage({
    Key? key,
    required this.idSiswa,
    required this.idIdentitasSekolah,
  }) : super(key: key);

  @override
  State<SmartCharacterPage> createState() => _SmartCharacterPageState();
}

class _SmartCharacterPageState extends State<SmartCharacterPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGrey,
      appBar: AppBar(
        title: const Text(titleSmartKarakter), backgroundColor: Color(0xFF047480)),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: itemList(),
      ),
    );
  }

  Widget itemList() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SmartBacaTulisAlquran(idSiswa: widget.idSiswa))),
                child: Image.asset("assets/character/baca_tulis_alquran.png",)),
            const SizedBox(height: 16,),
            GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SmartHafalanSurahAlquran(idSiswa: widget.idSiswa))),
                child: Image.asset("assets/character/hafalan_surah_alquran.png",)),
            const SizedBox(height: 16,),
            GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SmartFiqiHadist(idSiswa: widget.idSiswa))),
                child: Image.asset("assets/character/fiqih_dan_hadist.png",)),
            const SizedBox(height: 16,),
            GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SmartAmaliah( idSiswa: widget.idSiswa,idIdentitasSekolah: widget.idIdentitasSekolah,))),
                child: Image.asset("assets/character/amaliah_keagamaan.png",)),
            const SizedBox(height: 16,),
            GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SmartKategoriPenguatanKarakterTematik(idIdentitasSekolah: widget.idIdentitasSekolah,))),
                child: Image.asset("assets/character/penguatan_karakter_tematik.png",)),
          ],
        ),
      )
    );
  }
}
