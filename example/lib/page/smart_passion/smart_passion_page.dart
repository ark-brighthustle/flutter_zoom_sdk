import 'package:flutter/material.dart';

import '../../services/passion/passion_service.dart';
import '../../theme/padding.dart';
import '../../utils/constant.dart';

class SmartPassionPage extends StatefulWidget {
  const SmartPassionPage({Key? key}) : super(key: key);

  @override
  State<SmartPassionPage> createState() => _SmartPassionPageState();
}

class _SmartPassionPageState extends State<SmartPassionPage> {
  String assetIcon = "assets/icon/coming-soon.png";
  List categoriesPassionList = [];
  List passionList = [];

  Future _categoriesPassion() async {
    var response = await PassionService().getCategoryPassion();
    if (!mounted) return;
    setState(() {
      categoriesPassionList = response;
    });
  }

  Future _passion() async {
    var response = await PassionService().getPassion();
    if (!mounted) return;
    setState(() {
      passionList = response;
    });
  }

  @override
  void initState() {
    //_categoriesPassion();
    //_passion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(titleSmartPassion),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(padding),
        child: Center(child: Image.asset(assetIcon, width: 120,))
      ),
    );
  }

  Widget titleHeader() {
    return const Padding(
      padding: EdgeInsets.only(bottom: padding),
      child: Text(
        "Pilih Kategori dulu",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget itemPassionList() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleHeader(),
        Expanded(
          child: ListView.builder(
              itemCount: categoriesPassionList.length,
              itemBuilder: (context, i) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(categoriesPassionList[i].name),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                      ),
                    ),
                    const Divider(thickness: 1,)
                  ],
                );
              }),
        ),
      ],
    );
  }
}
