import 'package:flutter/material.dart';

import '../../theme/colors.dart';
import '../../utils/constant.dart';

class SmartLibraryPage extends StatefulWidget {
  const SmartLibraryPage({Key? key}) : super(key: key);

  @override
  State<SmartLibraryPage> createState() => _SmartLibraryPageState();
}

class _SmartLibraryPageState extends State<SmartLibraryPage> {
  String assetIcon = "assets/icon/coming-soon.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(titleSmartLibrary),
      ),
      backgroundColor: kGrey,
      body: Center(child: Image.asset(assetIcon, width: 120,),),
    );
  }
}
