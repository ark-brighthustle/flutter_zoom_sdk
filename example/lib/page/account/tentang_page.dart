import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../theme/colors.dart';
import '../../theme/padding.dart';
import '../../utils/constant.dart';

class TentangPage extends StatefulWidget {
  const TentangPage({Key? key}) : super(key: key);

  @override
  State<TentangPage> createState() => _TentangPageState();
}

class _TentangPageState extends State<TentangPage> {
  String? _appName;
  String? _version;
  String? _packageName;
  String? _buildNumber; 

  initPackageInfo() async {
    final _packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appName = _packageInfo.appName;
      _version = _packageInfo.version;
      _packageName = _packageInfo.packageName;
      _buildNumber = _packageInfo.buildNumber;
    });
  }

  @override
  void initState() {
    initPackageInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          children: [buildHeader(), buildItem()],
        ),
      ),
    ));
  }

  Widget iconBackButton() {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back),
      color: kBlack,
      iconSize: 20,
    );
  }

  Widget buildHeader() {
    return Row(
      children: [
        iconBackButton(),
        const SizedBox(width: 12,),
        const Text(textTentang, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),)
      ],
    );
  }

  Widget buildItem() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("App Name", style: TextStyle(fontWeight: FontWeight.w600),),
              Text("$_appName")
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Version", style: TextStyle(fontWeight: FontWeight.w600),),
              Text("$_version")
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Flexible(child: Text("Package Name", style: TextStyle(fontWeight: FontWeight.w600),)),
              Text("$_packageName", textAlign: TextAlign.end,)
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Build Number", style: TextStyle(fontWeight: FontWeight.w600),),
              Text("$_buildNumber")
            ],
          ),
        )
      ],
    );
  }
}