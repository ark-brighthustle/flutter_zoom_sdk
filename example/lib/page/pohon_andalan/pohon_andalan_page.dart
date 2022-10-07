import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../theme/padding.dart';
import '../../utils/constant.dart';
import 'pohon_disekolahku_page.dart';
import 'pohonku_page.dart';

class PohonAndalanPage extends StatefulWidget {
  final String idSiswa;
  const PohonAndalanPage({Key? key, required this.idSiswa}) : super(key: key);

  @override
  State<PohonAndalanPage> createState() => _PohonAndalanPageState();
}

class _PohonAndalanPageState extends State<PohonAndalanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGrey,
      appBar: AppBar(
        title: const Text(titlePohonAndalan),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(padding),
        child: kategoriPohonAndalan(),
      ),
    );
  }

  Widget kategoriPohonAndalan() {
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PohonDisekolahkuPage(idSiswa: widget.idSiswa.toString()))),
              child: Image.asset("assets/pohon_andalan/pohon_di_sekolahku.png",)),
          const SizedBox(height: 16,),
          GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PohonkuPage(idSiswa: widget.idSiswa.toString()))),
              child: Image.asset("assets/pohon_andalan/pohonku.png",)),
          const SizedBox(height: 16,),
        ],
      ),
    );
  }
}