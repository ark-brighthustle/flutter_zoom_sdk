import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../utils/constant.dart';

class PohonDisekolahkuPage extends StatefulWidget {
  final String idSiswa;
  const PohonDisekolahkuPage({Key? key, required this.idSiswa}) : super(key: key);

  @override
  State<PohonDisekolahkuPage> createState() => _PohonDisekolahkuPageState();
}

class _PohonDisekolahkuPageState extends State<PohonDisekolahkuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGrey,
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              titlePohonAndalan,
            ),
            Visibility(
              visible: true,
              child: Text(
                "Pohon Di Sekolahku",
                style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(child: Text("Coming Soon"),),
    );
  }
}
