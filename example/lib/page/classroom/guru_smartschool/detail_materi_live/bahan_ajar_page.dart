import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class BahanAjarPage extends StatefulWidget {
  final String bahanAjar;
  const BahanAjarPage({Key? key, required this.bahanAjar}) : super(key: key);

  @override
  State<BahanAjarPage> createState() => _BahanAjarPageState();
}

class _BahanAjarPageState extends State<BahanAjarPage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    _pdfViewerKey.currentState?.openBookmarkView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SfPdfViewer.network(widget.bahanAjar, key: _pdfViewerKey,),
        ),
      ),
    );
  }
}