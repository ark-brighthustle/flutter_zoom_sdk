import 'package:flutter/material.dart';

import '../../utils/constant.dart';

class SmartDiaryPage extends StatefulWidget {
  const SmartDiaryPage({Key? key}) : super(key: key);

  @override
  State<SmartDiaryPage> createState() => _SmartDiaryPageState();
}

class _SmartDiaryPageState extends State<SmartDiaryPage> {
  String assetIcon = "assets/icon/coming-soon.png";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(titleSmartDiary),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Center(child: Image.asset(assetIcon, width: 120,))),
    );
  }
}
