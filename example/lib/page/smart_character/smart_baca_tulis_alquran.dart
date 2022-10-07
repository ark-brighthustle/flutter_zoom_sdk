import 'package:flutter/material.dart';

import '../../services/character/character_service.dart';
import '../../theme/colors.dart';
import '../../theme/padding.dart';
import '../../utils/constant.dart';

class SmartBacaTulisAlquran extends StatefulWidget {
  final String idSiswa;
  const SmartBacaTulisAlquran({Key? key, required this.idSiswa}) : super(key: key);

  @override
  State<SmartBacaTulisAlquran> createState() => _SmartBacaTulisAlquranState();
}

class _SmartBacaTulisAlquranState extends State<SmartBacaTulisAlquran> {
  String? statusTulis;
  String? statusBaca;

  Future _getTulisAlquranResource() async {
    var response = await CharacterService().getDataTulisAlQuran(widget.idSiswa.toString());
    if (!mounted) return;
    setState(() {
      statusTulis = response['data']['status'];
    });
  }

  Future _getBacaAlquranResource() async {
    var response = await CharacterService().getDataBacaAlQuran(widget.idSiswa.toString());
    if (!mounted) return;
    if(response['data'] != null) {
      setState(() {
        statusBaca = response['data']['status'];
      });
    }
  }

  @override
  void initState() {
    _getTulisAlquranResource();
    _getBacaAlquranResource();
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
        child: itemBacaTulisAlQuran(),
      )),
    );
  }

  Widget itemBacaTulisAlQuran() {
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
                      "Baca Tulis Al-Qur'an",
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
            child: statusBaca == null || statusTulis == null
              ? Center(
                  child: CircularProgressIndicator()
                )
              : itemBacaTulis()
          ),
        ),
      ],
    );
  }

  Widget itemBacaTulis(){
    return Column(
      children: [
        if(statusTulis == "Cukup Bisa Menulis")...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset("assets/character/baca_tulis_alquran/TA_cukup_bisa_menulis.png",),
          ),
        ]else if(statusTulis == "Belum Bisa Menulis")...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset("assets/character/baca_tulis_alquran/TA_belum_bisa_menulis.png",),
          ),
        ],
        if(statusBaca == "Belum Bisa Baca")...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset("assets/character/baca_tulis_alquran/BA_belum_bisa_baca.png",),
          )
        ]else if(statusBaca == "Mengeja")...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset("assets/character/baca_tulis_alquran/BA_mengeja.png",),
          )
        ]else if(statusBaca == "Lancar")...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset("assets/character/baca_tulis_alquran/BA_lancar.png",),
          )
        ]else if(statusBaca == "Tajwid")...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset("assets/character/baca_tulis_alquran/BA_tajwid.png",),
          )
        ]else if(statusBaca == "Hafal Juz 30")...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset("assets/character/baca_tulis_alquran/BA_hafal_jus_30.png",),
          )
        ]else if(statusBaca == "Hafal > 5 Juz")...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.asset("assets/character/baca_tulis_alquran/BA_hafal_5_juz.png",),
          )
        ],
        // SingleChildScrollView(),
      ],
    );
  }
}