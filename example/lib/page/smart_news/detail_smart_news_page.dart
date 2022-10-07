import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/constant.dart';

class DetailSmartNewsPage extends StatefulWidget {
  final String linkBerita;
  const DetailSmartNewsPage(
      {Key? key,
      required this.linkBerita})
      : super(key: key);

  @override
  State<DetailSmartNewsPage> createState() => _DetailSmartNewsPageState();
}

class _DetailSmartNewsPageState extends State<DetailSmartNewsPage> {

  @override
  void initState() {
     if (Platform.isAndroid) WebView.platform = AndroidWebView();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(titleSmartNews),),
      body: WebView(initialUrl: widget.linkBerita,));
  }
}
 